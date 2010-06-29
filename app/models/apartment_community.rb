class ApartmentCommunity < Community
  before_update :mark_dirty_floor_plan_prices
  after_update :update_floor_plan_prices

  has_many :photos
  has_many :floor_plans

  validates_inclusion_of :use_market_prices, :in => [true, false]

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
