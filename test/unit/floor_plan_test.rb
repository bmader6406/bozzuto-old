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

    context 'when asking for min and max rents' do
      setup do
        @community = Community.make
        @group = FloorPlanGroup.make :community => @community
        @plan = FloorPlan.make(
          :min_market_rent    => 100,
          :max_market_rent    => 200,
          :min_effective_rent => 300,
          :max_effective_rent => 400,
          :floor_plan_group   => @group
        )
        @community.reload
      end

      context 'and community is not using market prices' do
        setup do
          @community.use_market_prices = false
          @community.save
        end

        should 'return effective rents' do
          assert_equal @plan.min_effective_rent, @plan.min_rent
          assert_equal @plan.max_effective_rent, @plan.max_rent
        end
      end

      context 'and community is using market prices' do
        setup do
          @community.use_market_prices = true
          @community.save
        end

        should 'return market rents' do
          assert_equal @plan.min_market_rent, @plan.min_rent
          assert_equal @plan.max_market_rent, @plan.max_rent
        end
      end
    end
  end
end
