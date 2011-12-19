class ApartmentCommunity < Community
  VAULTWARE_ATTRIBUTES = [
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

  validates_inclusion_of :use_market_prices, :in => [true, false]

  validates_presence_of :lead_2_lease_email, :if => lambda { |community| community.show_lead_2_lease }


  named_scope :with_floor_plan_groups, lambda {|ids|
    {:conditions => ["properties.id IN (SELECT apartment_community_id FROM apartment_floor_plans WHERE floor_plan_group_id IN (?))", ids]}
  }
  named_scope :with_property_features, lambda { |ids|
    {:conditions => ["properties.id IN (SELECT property_id FROM properties_property_features WHERE property_feature_id IN (?))", ids]}
  }
  named_scope :with_min_price, lambda {|price|
    {:conditions => ['properties.id IN (SELECT apartment_community_id FROM apartment_floor_plans WHERE min_rent >= ?)', price.to_i]}
  }
  named_scope :with_max_price, lambda {|price|
    {:conditions => ['properties.id IN (SELECT apartment_community_id FROM apartment_floor_plans WHERE max_rent <= ?)', price.to_i]} if price.to_i > 0
  }
  named_scope :featured, :conditions => ["properties.id IN (SELECT apartment_community_id FROM apartment_floor_plans WHERE featured = ?)", true]

  named_scope :managed_by_vaultware, :conditions => 'vaultware_id IS NOT NULL'


  def nearby_communities(limit = 6)
    @nearby_communities ||= city.apartment_communities.published.near(self).all(:limit => limit)
  end
  
  def cheapest_rent
    floor_plans.minimum(:min_rent)
  end
  
  def max_rent
    floor_plans.maximum(:max_rent)
  end
  
  def floor_plans_by_group
    floor_plan_groups.map do |group|
      [group, floor_plans.in_group(group).has_min_rent]
    end
  end

  def managed_by_vaultware?
    vaultware_id.present?
  end

  def merge(other_community)
    raise 'Receiver must not be a Vaultware-managed community' if managed_by_vaultware?
    raise 'Argument must be a Vaultware-managed community' unless other_community.managed_by_vaultware?

    self.vaultware_id = other_community.vaultware_id
    self.floor_plans  = other_community.floor_plans

    # copy other community's Vaultware attributes
    attrs = VAULTWARE_ATTRIBUTES.reject { |attr| attr == :floor_plans }
    attrs.each { |attr|
      self.send("#{attr}=", other_community.send(attr))
    }

    save

    # reload floor plans to clear other_community's cache so it doesn't delete them
    other_community.floor_plans(true)
    other_community.destroy
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
end
