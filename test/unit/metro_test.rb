require 'test_helper'

class MetroTest < ActiveSupport::TestCase
  context "A Metro" do
    subject { Metro.make }

    should_have_neighborhood_listing_image
    should_be_mappable

    should_validate_presence_of(:name)
    should_validate_presence_of(:latitude)
    should_validate_presence_of(:longitude)

    should_validate_uniqueness_of(:name)

    should_have_many(:areas, :dependent => :destroy)

    describe "nested structure" do
      before do
        # metro
        #   - area_1
        #     - neighborhood_1
        #       - community_1
        #         - floor_plan_1
        #       - community_2
        #         - floor_plan_2
        #     - neighborhood_2
        #   - area_2
        #     - neighborhood_3
        #       - community_1
        #         - floor_plan_1

        @community_1 = ApartmentCommunity.make
        @community_2 = ApartmentCommunity.make

        @floor_plan_1 = ApartmentFloorPlan.make(:apartment_community => @community_1)
        @floor_plan_2 = ApartmentFloorPlan.make(:apartment_community => @community_2)

        @neighborhood_1 = Neighborhood.make(:apartment_communities => [@community_1, @community_2])
        @neighborhood_2 = Neighborhood.make
        @neighborhood_3 = Neighborhood.make(:apartment_communities => [@community_1])

        @area_1 = Area.make(:neighborhoods => [@neighborhood_1, @neighborhood_2])
        @area_2 = Area.make(:neighborhoods => [@neighborhood_3])

        subject.areas = [@area_1, @area_2]
        subject.save
      end

      describe "#parent" do
        it "returns nil" do
          subject.parent.should == nil
        end
      end

      describe "#children" do
        it "returns the areas" do
          subject.children.should == [@area_1, @area_2]
        end
      end

      describe "#communities" do
        it "returns all of the unique communities" do
          subject.communities.should == [@community_1, @community_2]
        end
      end

      describe "#available_floor_plans" do
        it "returns all of the unique floor plans" do
          subject.available_floor_plans.should == [@floor_plan_1, @floor_plan_2]
        end
      end

      describe "after saving" do
        it "updates the apartment communities count" do
          subject.apartment_communities_count.should == 2
        end
      end
    end

    describe "#name_with_count" do
      context "count is greater than 0" do
        before do
          subject.apartment_communities_count = 5
        end

        it "returns the name with the count" do
          subject.name_with_count.should == "#{subject.name} (5)"
        end
      end

      context "count is zero" do
        before do
          subject.apartment_communities_count = 0
        end

        it "returns just the name" do
          subject.name_with_count.should == subject.name
        end
      end
    end
  end
end
