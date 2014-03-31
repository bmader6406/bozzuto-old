class ApartmentFloorPlanCache < ActiveRecord::Base
  belongs_to :cacheable, :polymorphic => true

  validates_presence_of :cacheable

  validates_numericality_of :studio_min_price,
                            :one_bedroom_min_price,
                            :two_bedrooms_min_price,
                            :three_bedrooms_min_price,
                            :penthouse_min_price,
                            :min_price,
                            :max_price,
                            :greater_than_or_equal_to => 0

  validates_numericality_of :studio_count,
                            :one_bedroom_count,
                            :two_bedrooms_count,
                            :three_bedrooms_count,
                            :penthouse_count,
                            :greater_than_or_equal_to => 0,
                            :integer_only             => true

  def min_rent
    min_price
  end

  def max_rent
    max_price
  end

  def cheapest_price_in_group(group)
    send(min_price_attr(group))
  end

  def plan_count_in_group(group)
    send(count_attr(group))
  end

  def update_cache
    ApartmentFloorPlanGroup.all.each do |group|
      cache_min_price_for_group(group)
      cache_count_for_group(group)
    end

    cache_min_and_max_prices

    save
  end

  def invalidate!
    destroy
  end


  private

  def floor_plans_for_caching
    cacheable.floor_plans_for_caching
  end

  def floor_plans_in_group_for_caching(group)
    cacheable.floor_plans_in_group_for_caching(group)
  end

  def cache_min_price_for_group(group)
    cheapest_price = floor_plans_in_group_for_caching(group).
                      with_min_rent.
                      try(:min_rent) || 0

    write_attribute(min_price_attr(group), cheapest_price)
  end

  def cache_count_for_group(group)
    count = floor_plans_in_group_for_caching(group).count

    write_attribute(count_attr(group), count)
  end

  def cache_min_and_max_prices
    self.min_price = floor_plans_for_caching.with_min_rent.try(:min_rent) || 0
    self.max_price = floor_plans_for_caching.with_max_rent.try(:max_rent) || 0
  end

  def min_price_attr(group)
    :"#{group.cache_name}_min_price"
  end

  def count_attr(group)
    :"#{group.cache_name}_count"
  end
end
