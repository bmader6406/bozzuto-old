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

    should "know the cheapest floor plan" do
      assert_equal @lowest_priced, @group.floor_plans.cheapest
    end
  end
end
