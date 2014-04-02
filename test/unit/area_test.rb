require 'test_helper'

class AreaTest < ActiveSupport::TestCase
  context "An Area" do
    subject { Area.make }

    should_have_neighborhood_listing_image
    should_be_mappable

    should_validate_presence_of(:name)
    should_validate_presence_of(:latitude)
    should_validate_presence_of(:longitude)
    should_validate_presence_of(:metro)
    should_validate_presence_of(:area_type)

    should_validate_uniqueness_of(:name)

    should_allow_values_for(:area_type, 'neighborhoods', 'communities')
    should_not_allow_values_for(:area_type, 'blaugh', nil)

    should_have_many(:neighborhoods, :dependent => :destroy)
    should_belong_to(:metro)
    should_belong_to(:state)
    should_have_many(:area_memberships, :dependent => :destroy)
    should_have_many(:apartment_communities, :through => :area_memberships)
    should_have_one_seo_metadata

    describe "nested structure" do
      context "area_type is 'neighborhoods'" do
        before do
          
          # area
          #   - neighborhood_1
          #     - community_1
          #       - floor_plan_1
          #     - community_2
          #       - floor_plan_2
          #     - community_3
          #   -neighborhood_2
          #     -community_1
          #       - floor_plan_1

          @community_1 = ApartmentCommunity.make
          @community_2 = ApartmentCommunity.make
          @community_3 = ApartmentCommunity.make

          @floor_plan_1 = ApartmentFloorPlan.make(:apartment_community => @community_1)
          @floor_plan_2 = ApartmentFloorPlan.make(:apartment_community => @community_2)

          @neighborhood_1 = Neighborhood.make(:apartment_communities => [@community_1, @community_2, @community_3])

          @neighborhood_2 = Neighborhood.make(:apartment_communities => [@community_1])

          subject.neighborhoods = [@neighborhood_1, @neighborhood_2]
          subject.save
        end

        describe "#parent" do
          it "returns the metro" do
            subject.parent.should == subject.metro
          end
        end

        describe "#children" do
          it "returns the neighborhoods" do
            subject.children.should == [@neighborhood_1, @neighborhood_2]
          end
        end

        describe "#lineage" do
          it "returns the metro and the area" do
            subject.lineage.should == [subject.metro, subject]
          end
        end

        describe "#communities" do
          it "returns all of the unique communities" do
            subject.communities.should == [@community_1, @community_2, @community_3]
          end
        end

        describe "#available_floor_plans" do
          it "returns all of the unique floor plans" do
            subject.available_floor_plans.should == [@floor_plan_1, @floor_plan_2]
          end
        end

        describe "after saving" do
          it "updates the apartment communities count" do
            subject.apartment_communities_count.should == 3
          end

          it "updates the parent metro" do
            subject.metro.apartment_communities_count.should == 3
          end
        end

        describe "after destroying" do
          it "updates the count on the parent metro" do
            metro = subject.metro
            metro.apartment_communities_count.should == 3

            subject.destroy

            metro.reload
            metro.apartment_communities_count.should == 0
          end
        end
      end

      context "area_type is 'communities'" do
        subject { Area.make(:communities) }

        before do
          # area
          #   - community_1
          #     - floor_plan_1
          #   - community_2
          #     - floor_plan_2

          @community_1 = ApartmentCommunity.make
          @community_2 = ApartmentCommunity.make

          @floor_plan_1 = ApartmentFloorPlan.make(:apartment_community => @community_1)
          @floor_plan_2 = ApartmentFloorPlan.make(:apartment_community => @community_2)

          subject.apartment_communities = [@community_1, @community_2]
          subject.save
        end

        describe "#parent" do
          it "returns the metro" do
            subject.parent.should == subject.metro
          end
        end

        describe "#children" do
          it "returns nil" do
            subject.children.should == nil
          end
        end

        describe "#lineage" do
          it "returns the metro and the area" do
            subject.lineage.should == [subject.metro, subject]
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

          it "updates the parent metro" do
            subject.metro.apartment_communities_count.should == 2
          end
        end

        describe "after destroying" do
          it "updates the count on the parent metro" do
            metro = subject.metro
            metro.apartment_communities_count.should == 2

            subject.destroy

            metro.reload
            metro.apartment_communities_count.should == 0
          end
        end
      end
    end

    describe "#shows_neighborhoods?" do
      context "area_type is 'neighborhoods'" do
        it "returns true" do
          subject.area_type = 'neighborhoods'
          subject.shows_neighborhoods?.should == true
        end
      end

      context "area_type is 'communities'" do
        it "returns false" do
          subject.area_type = 'communities'
          subject.shows_neighborhoods?.should == false
        end
      end
    end

    describe "#shows_communities?" do
      context "area_type is 'neighborhoods'" do
        it "returns false" do
          subject.area_type = 'neighborhoods'
          subject.shows_communities?.should == false
        end
      end

      context "area_type is 'communities'" do
        it "returns true" do
          subject.area_type = 'communities'
          subject.shows_communities?.should == true
        end
      end
    end
  end
end
