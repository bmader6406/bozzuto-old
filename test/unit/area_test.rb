require 'test_helper'

class AreaTest < ActiveSupport::TestCase
  context "An Area" do
    subject { Area.make }

    should_validate_presence_of(:name)
    should_validate_presence_of(:latitude)
    should_validate_presence_of(:longitude)
    should_validate_presence_of(:metro)

    should_validate_uniqueness_of(:name)

    should_validate_attachment_presence(:listing_image)

    should_have_many(:neighborhoods, :dependent => :destroy)
    should_belong_to(:metro)

    describe "nested structure" do
      before do
        # area
        #   - neighborhood_1
        #     - community
        #     - community
        #     - community
        #   -neighborhood_2
        #     -community

        @neighborhood_1 = Neighborhood.make(:neighborhood_memberships => (1..3).to_a.map { |_| NeighborhoodMembership.make_unsaved })
        @neighborhood_2 = Neighborhood.make(:neighborhood_memberships => [NeighborhoodMembership.make_unsaved])

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

      describe "#memberships" do
        it "returns all of the memberships" do
          subject.memberships.should == @neighborhood_1.memberships + @neighborhood_2.memberships
        end
      end

      describe "after saving" do
        it "updates the apartment communities count" do
          subject.apartment_communities_count.should == 4
        end

        it "updates the parent metro" do
          subject.metro.apartment_communities_count.should == 4
        end
      end

      describe "after destroying" do
        it "updates the count on the parent metro" do
          metro = subject.metro
          metro.apartment_communities_count.should == 4

          subject.destroy

          metro.reload
          metro.apartment_communities_count.should == 0
        end
      end
    end
  end
end
