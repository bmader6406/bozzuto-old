require 'test_helper'

class HomeNeighborhoodTest < ActiveSupport::TestCase
  context "A HomeNeighborhood" do
    subject { HomeNeighborhood.make }

    should_have_neighborhood_listing_image
    should_have_neighborhood_banner_image
    should_be_mappable
    should_have_seo_metadata

    should validate_presence_of(:name)
    should validate_presence_of(:latitude)
    should validate_presence_of(:longitude)

    should validate_uniqueness_of(:name)

    should belong_to(:featured_home_community)
    should have_many(:home_neighborhood_memberships).dependent(:destroy)
    should have_many(:home_communities).through(:home_neighborhood_memberships)

    describe "nested structure" do
      before do
        # neighborhood
        #   - community_1
        #   - community_2
        #   - community_3
        @community_1 = HomeCommunity.make
        @community_2 = HomeCommunity.make
        @community_3 = HomeCommunity.make

        subject.home_communities = [@community_1, @community_2, @community_3]
        subject.name = 'DC'
        subject.save
      end

      describe "#to_s" do
        it "returns the name" do
          subject.typus_name.should == 'DC'
        end
      end

      describe "#typus_name" do
        it "returns the name" do
          subject.typus_name.should == 'DC'
        end
      end

      describe "#full_name" do
        it "returns the full name" do
          subject.full_name.should == "DC Homes"
        end
      end

      describe "#communities" do
        it "returns all of the unique communities" do
          subject.communities.should == [@community_1, @community_2, @community_3]
        end
      end

      describe "#has_communities?" do
        context "when the neighborhood has communities" do
          it "returns true" do
            subject.has_communities?.should == true
          end
        end

        context "when the mtro does not have any communities" do
          it "returns false" do
            HomeNeighborhood.make.has_communities?.should == false
          end
        end
      end

      describe "after saving" do
        it "updates the home communities count" do
          subject.home_communities_count.should == 3
        end
      end
    end
  end
end
