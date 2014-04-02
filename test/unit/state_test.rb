require 'test_helper'

class StateTest < ActiveSupport::TestCase
  context "A State" do
    subject { State.make }

    should_have_many(:cities, :counties)
    should_have_many(:apartment_communities, :through => :cities)
    should_have_many(:home_communities, :through => :cities)
    should_have_many(:communities, :through => :cities)
    should_have_many(:featured_apartment_communities, :through => :cities)
    should_have_many(:neighborhoods)

    should_validate_presence_of(:code, :name)
    should_ensure_length_is(:code, 2)
    should_validate_uniqueness_of(:code, :name)

    describe "#to_param" do
      it "returns the code" do
        subject.to_param.should == subject.code
      end
    end

    describe "#to_s" do
      it "returns the name" do
        subject.to_s.should == subject.name
      end
    end

    describe "#places" do
      before do
        # neighborhood_1
        #   - community_1
        # area_1
        #   - community_2
        #   - community_3
        # area_2

        @community_1 = ApartmentCommunity.make
        @community_2 = ApartmentCommunity.make
        @community_3 = ApartmentCommunity.make

        @neighborhood_1 = Neighborhood.make(:state => subject, :apartment_communities => [@community_1])

        @area_1 = Area.make(:communities, :state => subject, :apartment_communities => [@community_1, @community_2])
        @area_2 = Area.make(:neighborhoods, :state => subject)
      end

      it "returns the places, sorted by apartment_communities_count" do
        subject.places.should == [@area_1, @neighborhood_1]
      end
    end
  end
end
