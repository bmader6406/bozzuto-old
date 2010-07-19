class ApartmentCommunity < Community
  before_update :mark_dirty_floor_plan_prices
  after_update :update_floor_plan_prices

  has_many :floor_plans, :class_name => 'ApartmentFloorPlan'
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

  def nearby_communities(limit = 6)
    @nearby_communities ||= city.apartment_communities.near(self).all(:limit => limit)
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
