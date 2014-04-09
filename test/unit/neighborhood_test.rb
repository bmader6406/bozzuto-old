require 'test_helper'

class NeighborhoodTest < ActiveSupport::TestCase
  context "A Neighborhood" do
    subject { Neighborhood.make }

    should_have_neighborhood_listing_image
    should_be_mappable

    should_validate_presence_of(:name)
    should_validate_presence_of(:latitude)
    should_validate_presence_of(:longitude)
    should_validate_presence_of(:area)
    should_validate_presence_of(:state)

    should_validate_uniqueness_of(:name)

    should_have_attached_file(:banner_image)
    should_validate_attachment_presence(:banner_image)

    should_belong_to(:area)
    should_belong_to(:state)
    should_belong_to(:featured_apartment_community)
    should_have_many(:neighborhood_memberships, :dependent => :destroy)
    should_have_many(:apartment_communities, :through => :neighborhood_memberships)
    should_have_one_seo_metadata

    should_have_many(:related_neighborhoods, :dependent => :destroy)
    should_have_many(:nearby_neighborhoods, :through => :related_neighborhoods)
    should_have_many(:neighborhood_relations, :dependent => :destroy)

    describe "nested structure" do
      before do
        # neighborhood
        #   - community_1
        #     - floor_plan_1
        #   - community_2
        #     - floor_plan_2
        #   - community_3
        @community_1 = ApartmentCommunity.make
        @community_2 = ApartmentCommunity.make
        @community_3 = ApartmentCommunity.make

        @floor_plan_1 = ApartmentFloorPlan.make(:apartment_community => @community_1)
        @floor_plan_2 = ApartmentFloorPlan.make(:apartment_community => @community_2)

        subject.apartment_communities = [@community_1, @community_2, @community_3]
        subject.save
      end

      describe "#typus_name" do
        it "returns the name" do
          subject.typus_name.should == subject.name
        end
      end

      describe "#parent" do
        it "returns the area" do
          subject.parent.should == subject.area
        end
      end

      describe "#children" do
        it "returns nil" do
          subject.children.should == nil
        end
      end

      describe "#lineage" do
        it "returns the metro, area, and the neighborhood" do
          subject.lineage.should == [subject.area.metro, subject.area, subject]
        end
      end

      describe "#lineage_hash" do
        it "returns the hash" do
          subject.lineage_hash.should == {
            :metro        => subject.area.metro,
            :area         => subject.area,
            :neighborhood => subject
          }
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

        it "updates the parent area" do
          subject.area.apartment_communities_count.should == 3
        end
      end

      describe "after destroying" do
        it "updates the count on the parent area" do
          area = subject.area
          area.apartment_communities_count.should == 3

          subject.destroy

          area.reload
          area.apartment_communities_count.should == 0
        end
      end
    end

    describe "#nearby_communities" do
      before do
        # nearby_1
        #   - community_1
        #   - community_2
        # nearby_2
        #   - community_1

        @community_1 = ApartmentCommunity.make
        @community_2 = ApartmentCommunity.make

        @nearby_1 = Neighborhood.make(:apartment_communities => [@community_1, @community_2])
        @nearby_2 = Neighborhood.make(:apartment_communities => [@community_1])

        subject.nearby_neighborhoods = [@nearby_1, @nearby_2]
        subject.save
      end

      it "returns the nearby communities" do
        subject.nearby_communities.should == [@community_1, @community_2]
      end
    end
  end
end
