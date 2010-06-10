require 'test_helper'

class FloorPlanGroupTest < ActiveSupport::TestCase
  context "A floor plan group" do
    setup do
      @group = FloorPlanGroup.make
    end

    should_have_many :floor_plans
    should_belong_to :community

    should_validate_presence_of :name

    context "floor plans association" do
      setup do
        @largest = @group.floor_plans.make({
          :min_market_rent    => 2000,
          :min_effective_rent => 2000,
          :max_square_feet    => 800
        })
        @cheapest_market = @group.floor_plans.make({
          :min_market_rent    => 800,
          :min_effective_rent => 1000,
          :max_square_feet    => 400
        })
        @cheapest_effective = @group.floor_plans.make({
          :min_market_rent    => 1000,
          :min_effective_rent => 800,
          :max_square_feet    => 400
        })
      end

      should "be able to find the largest floor plan" do
        assert_equal @largest, @group.floor_plans.largest
      end

      context 'when not using market prices' do
        setup do
          @group.expects(:use_market_prices?).returns(false)
        end

        should 'be able to find the cheapest floor plan by effective rent' do
          assert_equal @cheapest_effective, @group.floor_plans.cheapest
        end
      end

      context 'when using market prices' do
        setup do
          @group.expects(:use_market_prices?).returns(true)
        end

        should 'be able to find the cheapest floor plan by market rent' do
          assert_equal @cheapest_market, @group.floor_plans.cheapest
        end
      end
    end
  end
end
