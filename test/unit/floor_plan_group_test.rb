require 'test_helper'

class FloorPlanGroupTest < ActiveSupport::TestCase
  context "A floor plan group" do
    setup do
      @group = FloorPlanGroup.make
      @group.floor_plans.make(:price => 200000)
      @lowest_priced = @group.floor_plans.make(:price => 100000)
    end

    should_have_many :floor_plans
    should_belong_to :community

    should_validate_presence_of :name

    context "floor plans association" do
      setup do
        @group = FloorPlanGroup.make
        @largest = @group.floor_plans.make({
          :price       => 200000,
          :square_feet => 800
        })
        @cheapest = @group.floor_plans.make({
          :price       => 100000,
          :square_feet => 400
        })
      end

      should "be able to find the cheapest floor plan" do
        assert_equal @cheapest, @group.floor_plans.cheapest
      end

      should "be able to find the largest floor plan" do
        assert_equal @largest, @group.floor_plans.largest
      end
    end
  end
end
