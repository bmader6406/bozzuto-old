require 'test_helper'

class MetroTest < ActiveSupport::TestCase
  context "A Metro" do
    subject { Metro.make }

    should_validate_presence_of(:name)
    should_validate_presence_of(:latitude)
    should_validate_presence_of(:longitude)

    should_validate_uniqueness_of(:name)

    should_validate_attachment_presence(:listing_image)

    should_have_many(:areas, :dependent => :destroy)

    describe "nested structure" do
      before do
        # metro
        #   - area_1
        #     - neighborhood_1
        #       -community
        #       -community
        #     - neighborhood_2
        #   - area_2
        #     - neighborhood_3
        #       - community

        @neighborhood_1 = Neighborhood.make(:neighborhood_memberships => (1..2).to_a.map { |_| NeighborhoodMembership.make_unsaved })
        @neighborhood_2 = Neighborhood.make
        @neighborhood_3 = Neighborhood.make(:neighborhood_memberships => [NeighborhoodMembership.make_unsaved])

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

      describe "#memberships" do
        it "returns all of the memberships" do
          subject.memberships.should == @neighborhood_1.memberships + @neighborhood_3.memberships
        end
      end

      describe "after saving" do
        it "updates the apartment communities count" do
          subject.apartment_communities_count.should == 3
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
