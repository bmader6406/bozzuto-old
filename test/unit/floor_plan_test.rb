require 'test_helper'

class FloorPlanTest < ActiveSupport::TestCase
  context "A floor plan" do
    setup do
      @plan = FloorPlan.new
    end

    should_belong_to :floor_plan_group

    should_validate_presence_of :name,
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
    should_validate_numericality_of :bedrooms,
      :bathrooms,
      :min_square_feet,
      :max_square_feet,
      :min_market_rent,
      :max_market_rent,
      :min_effective_rent,
      :max_effective_rent
  end
end
