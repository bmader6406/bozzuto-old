require 'test_helper'

class ApartmentFloorPlanCacheTest < ActiveSupport::TestCase
  context "An Apartment Floor Plan Cache" do
    subject { ApartmentFloorPlanCache.new }

    should validate_presence_of(:cacheable)

    should validate_numericality_of(:studio_min_price)
    should validate_numericality_of(:one_bedroom_min_price)
    should validate_numericality_of(:two_bedrooms_min_price)
    should validate_numericality_of(:three_bedrooms_min_price)
    should validate_numericality_of(:penthouse_min_price)

    should validate_numericality_of(:studio_count)
    should validate_numericality_of(:one_bedroom_count)
    should validate_numericality_of(:two_bedrooms_count)
    should validate_numericality_of(:three_bedrooms_count)
    should validate_numericality_of(:penthouse_count)

    describe "#update_cache" do
      before do
        create_floor_plan_groups

        @community = ApartmentCommunity.make

        ApartmentFloorPlanGroup.all.each_with_index do |group, i|
          ApartmentFloorPlan.make(
            :apartment_community => @community,
            :floor_plan_group    => group,
            :min_rent            => (i * 10) + 50.0,
            :max_rent            => (i * 100) + 100.0
          )
        end

        @community.apartment_floor_plan_cache.should == nil
      end

      subject { ApartmentFloorPlanCache.new(:cacheable => @community) }


      it "updates the cache values" do
        subject.update_cache

        subject.studio_min_price.should         == 50.0
        subject.studio_count.should             == 1
        subject.one_bedroom_min_price.should    == 60.0
        subject.one_bedroom_count.should        == 1
        subject.two_bedrooms_min_price.should   == 70.0
        subject.two_bedrooms_count.should       == 1
        subject.three_bedrooms_min_price.should == 80.0
        subject.three_bedrooms_count.should     == 1
        subject.penthouse_min_price.should      == 90.0
        subject.penthouse_count.should          == 1

        subject.min_price.should == 50.0
        subject.max_price.should == 500.0
      end
    end

    describe "#invalidate!" do
      before do
        @community = ApartmentCommunity.make
        @community.fetch_apartment_floor_plan_cache
      end

      subject { @community.apartment_floor_plan_cache }

      it "destroys the cache" do
        subject.invalidate!
        subject.destroyed?.should == true
      end
    end
  end
end
