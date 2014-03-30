require 'test_helper'

class ApartmentFloorPlanCacheTest < ActiveSupport::TestCase
  context "An Apartment Floor Plan Cache" do
    subject { ApartmentFloorPlanCache.new }

    should_validate_presence_of(:cacheable)

    should_validate_numericality_of(:studio_min_price)
    should_validate_numericality_of(:one_bedroom_min_price)
    should_validate_numericality_of(:two_bedrooms_min_price)
    should_validate_numericality_of(:three_bedrooms_min_price)
    should_validate_numericality_of(:penthouse_min_price)

    should_validate_numericality_of(:studio_count)
    should_validate_numericality_of(:one_bedroom_count)
    should_validate_numericality_of(:two_bedrooms_count)
    should_validate_numericality_of(:three_bedrooms_count)
    should_validate_numericality_of(:penthouse_count)

    describe "#update_apartment_floor_plan_cache_for_group" do
      before do
        @studio = ApartmentFloorPlanGroup.make(:studio)

        @community = ApartmentCommunity.make

        @plan = ApartmentFloorPlan.make(
          :apartment_community => @community,
          :floor_plan_group    => @studio,
          :min_effective_rent  => 50.0,
          :max_effective_rent  => 100.0
        )

        @community.cheapest_price_in_group(@studio).should == 50.0
        @community.plan_count_in_group(@studio).should == 1
      end

      subject { @community.apartment_floor_plan_cache }

      it "updates the cache values" do
        subject.studio_min_price = 1000.0
        subject.studio_count     = 50
        subject.save

        @community.update_apartment_floor_plan_cache_for_group(@studio)

        subject.studio_min_price.should == 50.0
        subject.studio_count.should == 1
      end
    end

    describe "#update_apartment_floor_plan_cache" do
      before do
        create_floor_plan_groups

        @community = ApartmentCommunity.make

        ApartmentFloorPlanGroup.all.each_with_index do |group, i|
          ApartmentFloorPlan.make(
            :apartment_community => @community,
            :floor_plan_group    => group,
            :min_effective_rent  => (i * 10) + 50.0,
            :max_effective_rent  => (i * 100) + 100.0
          )
        end

        @community.apartment_floor_plan_cache.destroy
        @community.reload
        @community.apartment_floor_plan_cache.should == nil
      end


      it "updates the cache values" do
        @community.update_apartment_floor_plan_cache

        cache = @community.apartment_floor_plan_cache

        cache.studio_min_price         = 50.0
        cache.studio_count             = 1
        cache.one_bedroom_min_price    = 60.0
        cache.one_bedroom_count        = 1
        cache.two_bedrooms_min_price   = 70.0
        cache.two_bedrooms_count       = 1
        cache.three_bedrooms_min_price = 80.0
        cache.three_bedrooms_count     = 1
        cache.penthouse_min_price      = 90.0
        cache.penthouse_count          = 1

        cache.min_price.should == 50.0
        cache.max_price.should == 500.0
      end
    end
  end
end
