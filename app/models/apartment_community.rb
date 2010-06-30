class ApartmentCommunity < Community
  before_update :mark_dirty_floor_plan_prices
  after_update :update_floor_plan_prices

  has_many :photos
  has_many :floor_plans

  validates_inclusion_of :use_market_prices, :in => [true, false]

  named_scope :with_floor_plan_groups, lambda {|ids|
    {:conditions => ["properties.id IN (SELECT apartment_community_id FROM floor_plans WHERE floor_plan_group_id IN (?))", ids]}
  }
  named_scope :with_min_price, lambda {|price|
    {:conditions => ['properties.id IN (SELECT apartment_community_id FROM floor_plans WHERE min_rent >= ?)', price.to_i]}
  }
  named_scope :with_max_price, lambda {|price|
    {:conditions => ['properties.id IN (SELECT apartment_community_id FROM floor_plans WHERE max_rent <= ?)', price.to_i]} if price.to_i > 0
  }

  include FlagShihTzu
  has_flags :column => 'features',
                  1 => :fitness_center,
                  2 => :metro_access,
                  3 => :pet_friendly,
                  4 => :washer_and_dryer,
                  5 => :brand_new

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
