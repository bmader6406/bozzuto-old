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

    describe "nested structure" do
      before do
        # neighborhood
        #   - community
        #   - community
        #   - community
        @community_1 = ApartmentCommunity.make
        @community_2 = ApartmentCommunity.make
        @community_3 = ApartmentCommunity.make

        subject.apartment_communities = [@community_1, @community_2, @community_3]
        subject.save
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

      describe "#communities" do
        it "returns all of the unique communities" do
          subject.communities.should == [@community_1, @community_2, @community_3]
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

      describe "#after destroying" do
        it "updates the count on the parent area" do
          area = subject.area
          area.apartment_communities_count.should == 3

          subject.destroy

          area.reload
          area.apartment_communities_count.should == 0
        end
      end
    end
  end
end
