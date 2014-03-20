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

    describe "after saving" do
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

        @neighborhood_1 = Neighborhood.make(:apartment_communities => (1..2).to_a.map { |_| ApartmentCommunity.make })
        @neighborhood_2 = Neighborhood.make
        @neighborhood_3 = Neighborhood.make(:apartment_communities => [ApartmentCommunity.make])

        @area_1 = Area.make(:neighborhoods => [@neighborhood_1, @neighborhood_2])
        @area_2 = Area.make(:neighborhoods => [@neighborhood_3])

        subject.areas = [@area_1, @area_2]
        subject.save
      end

      it "updates the apartment communities count" do
        subject.apartment_communities_count.should == 3
      end
    end
  end
end
