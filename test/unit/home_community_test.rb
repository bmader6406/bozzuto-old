require 'test_helper'

class HomeCommunityTest < ActiveSupport::TestCase
  context 'HomeCommunity' do
    setup do
      @community = HomeCommunity.make
    end

    subject { @community }

    should_have_many :homes
    should_have_many :featured_homes
    should_have_attached_file :listing_promo

    context '#nearby_communities' do
      setup do
        @city = City.make
        @communities = []

        3.times do |i|
          @communities << HomeCommunity.make(:latitude => i, :longitude => i, :city => @city)
        end
      end

      should 'return the closest communities' do
        nearby = @communities[0].nearby_communities
        assert_equal 2, nearby.length
        assert_equal @communities[1], nearby[0]
        assert_equal @communities[2], nearby[1]
      end
    end
  end
end
