require 'test_helper'

class ApartmentFloorPlanObserverTest < ActiveSupport::TestCase
  context "An ApartmentFloorPlanObserver" do
    setup do
      @community = ApartmentCommunity.make
      @studio    = ApartmentFloorPlanGroup.make(:studio)
    end

    describe "saving a floor plan" do
      setup do
        @community.cheapest_price_in_group(@studio).should == 0.0
        @community.plan_count_in_group(@studio).should == 0
        @community.min_rent.should == 0.0
        @community.max_rent.should == 0.0
      end

      it "invalidates the cache" do
        ApartmentFloorPlan.make(
          :floor_plan_group    => @studio,
          :apartment_community => @community,
          :min_effective_rent  => 100.0,
          :max_effective_rent  => 500.0
        )

        @community.reload
        @community.apartment_floor_plan_cache.should == nil

        @community.cheapest_price_in_group(@studio).should == 100.0
        @community.plan_count_in_group(@studio).should == 1
        @community.min_rent.should == 100.0
        @community.max_rent.should == 500.0
      end
    end

    describe "destroying a floor plan" do
      setup do
        @plan = ApartmentFloorPlan.make(
          :floor_plan_group    => @studio,
          :apartment_community => @community,
          :min_effective_rent  => 100.0,
          :max_effective_rent  => 500.0
        )

        @community.cheapest_price_in_group(@studio).should == 100.0
        @community.plan_count_in_group(@studio).should == 1
        @community.min_rent.should == 100.0
        @community.max_rent.should == 500.0
      end

      it "invalidates the cache" do
        @plan.destroy

        @community.reload
        @community.apartment_floor_plan_cache.should == nil

        @community.cheapest_price_in_group(@studio).should == 0.0
        @community.plan_count_in_group(@studio).should == 0
        @community.min_rent.should == 0.0
        @community.max_rent.should == 0.0
      end
    end
  end
end
