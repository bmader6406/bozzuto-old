require 'test_helper'

class FloorPlanTest < ActiveSupport::TestCase
  context "A floor plan" do
    setup do
      @plan = FloorPlan.new
    end

    should_belong_to :floor_plan_group

    should_validate_presence_of :image, :category, :bedrooms, :bathrooms, :square_feet, :price, :floor_plan_group
    should_validate_numericality_of :bedrooms, :bathrooms, :square_feet, :price
  end
end
