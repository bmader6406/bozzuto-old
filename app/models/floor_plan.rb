class FloorPlan < ActiveRecord::Base
  belongs_to :floor_plan_group

  acts_as_list :scope => :floor_plan_group

  validates_presence_of :name,
    :availability_url,
    :bedrooms,
    :bathrooms,
    :min_square_feet,
    :max_square_feet,
    :min_market_rent,
    :max_market_rent,
    :min_effective_rent,
    :max_effective_rent,
    :floor_plan_group
  validates_numericality_of :bedrooms,
    :bathrooms,
    :min_square_feet,
    :max_square_feet,
    :min_market_rent,
    :max_market_rent,
    :min_effective_rent,
    :max_effective_rent,
    :minimum => 0
end
