require 'test_helper'

class ApartmentCommunityTest < ActiveSupport::TestCase
  context 'ApartmentCommunity' do
    setup do
      @community = ApartmentCommunity.make
    end

    subject { @community }

    should_have_many :photos
    should_have_many :floor_plan_groups
    should_have_many :floor_plans, :through => :floor_plan_groups

    context '#nearby_communities' do
      setup do
        @city = City.make
        @communities = []

        3.times do |i|
          @communities << ApartmentCommunity.make(:latitude => i, :longitude => i, :city => @city)
        end
      end

      should "return the closest communities" do
        nearby = @communities[0].nearby_communities
        assert_equal 2, nearby.length
        assert_equal @communities[1], nearby[0]
        assert_equal @communities[2], nearby[1]
      end
    end
  end
end
