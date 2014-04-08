class ApartmentCommunity < Community
  include Bozzuto::ExternalCms

  self.external_cms_attributes = [
    :title,
    :street_address,
    :city,
    :county,
    :availability_url,
    :floor_plans
  ]

  acts_as_archive :indexes => [:id]

  before_update :mark_dirty_floor_plan_prices
  after_update :update_floor_plan_prices

  has_many :floor_plans,
           :class_name => 'ApartmentFloorPlan',
           :dependent  => :destroy

  has_many :floor_plan_groups,
           :class_name => 'ApartmentFloorPlanGroup',
           :through    => :floor_plans,
           :uniq       => true

  has_many :featured_floor_plans,
           :class_name => 'ApartmentFloorPlan',
           :conditions => { :featured => true },
           :order      => 'bedrooms ASC, position ASC'

  has_many :under_construction_leads,
           :order => 'created_at DESC'

  has_one :mediaplex_tag, :as => :trackable

  has_one :contact_configuration,
          :class_name => 'ApartmentContactConfiguration'


  validates_inclusion_of :use_market_prices, :in => [true, false]

  validates_presence_of :lead_2_lease_email, :if => lambda { |community| community.show_lead_2_lease }


  named_scope :with_floor_plan_groups, lambda {|ids|
    {:conditions => ["properties.id IN (SELECT apartment_community_id FROM apartment_floor_plans WHERE floor_plan_group_id IN (?))", ids]}
  }
  named_scope :with_property_features, lambda { |ids|
    {:conditions => ["properties.id IN (SELECT property_id FROM properties_property_features WHERE property_feature_id IN (?))", ids]}
  }
  named_scope :with_min_price, lambda {|price|
    {:conditions => ['properties.max_rent >= ?', price.to_i]}
  }
  named_scope :with_max_price, lambda {|price|
    {:conditions => ['properties.min_rent <= ?', price.to_i]}
  }
  named_scope :featured, :conditions => ["properties.id IN (SELECT apartment_community_id FROM apartment_floor_plans WHERE featured = ?)", true]

  named_scope :under_construction, :conditions => { :under_construction => true }
  named_scope :not_under_construction, :conditions => { :under_construction => false }


  def nearby_communities(limit = 6)
    @nearby_communities ||= city.apartment_communities.published.near(self).all(:limit => limit)
  end

  def merge(other_community)
    raise 'Receiver must not be an externally-managed community' if managed_externally?
    raise 'Argument must be an externally-managed community' unless other_community.managed_externally?

    self.external_cms_id   = other_community.external_cms_id
    self.external_cms_type = other_community.external_cms_type

    self.class.external_cms_attributes.each { |attr|
      self.send("#{attr}=", other_community.send(attr))
    }

    save

    # reload floor plans to clear other_community's cache so it doesn't delete them
    other_community.floor_plans(true)
    other_community.destroy
  end

  def cheapest_price_in_group(group)
    send("cheapest_#{group.name_for_cache}_price")
  end

  def plan_count_in_group(group)
    send("plan_count_#{group.name_for_cache}")
  end

  def jmapping_category
    under_construction? ? 'UpcomingApartment' : super
  end

  def apartment_community?
    true
  end

  def disconnect_from_external_cms!
    self.external_cms_id   = nil
    self.external_cms_type = nil

    floor_plans.each do |plan|
      plan.disconnect_from_external_cms!
    end

    save
  end

  def available_floor_plans(reload = true)
    @available_floor_plans = nil if reload

    @available_floor_plans ||= if managed_externally?
      floor_plans.externally_available.available
    else
      floor_plans.available
    end
  end

  private

  def mark_dirty_floor_plan_prices
    @set_floor_plan_prices = use_market_prices_changed?
    true
  end

  def update_floor_plan_prices
    if @set_floor_plan_prices
      floor_plans.each do |plan|
        plan.set_rent_prices
        plan.save
      end
    end
    @set_floor_plan_prices = nil
    true
  end

  def cache_cheapest_price(group)
    cheapest_price = available_floor_plans.
                      in_group(group).
                      with_min_rent.
                      try(:min_rent)

    update_attribute("cheapest_#{group.name_for_cache}_price", cheapest_price)
  end

  def cache_plan_count(group)
    count = available_floor_plans.in_group(group).count

    update_attribute("plan_count_#{group.name_for_cache}", count)
  end

  def cache_min_and_max_rents
    update_attributes(
      :min_rent => available_floor_plans.with_min_rent.try(:min_rent),
      :max_rent => available_floor_plans.with_max_rent.try(:max_rent)
    )
  end
end
