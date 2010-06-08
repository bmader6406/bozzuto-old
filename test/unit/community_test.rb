require 'test_helper'

class CommunityTest < ActiveSupport::TestCase
  context "A community" do
    setup do
      @community = Community.make
    end

    subject { @community }

    should_belong_to :city
    should_have_many :photos
    should_have_many :floor_plan_groups
    should_have_many :floor_plans, :through => :floor_plan_groups
    should_belong_to :yelp_feed

    should_validate_presence_of :title, :subtitle, :city
    should_validate_numericality_of :latitude, :longitude

    context "#address" do
      setup do
        @address = '202 Rigsbee Ave'
        @community = Community.make(:street_address => @address)
      end

      should "return the formatted address" do
        assert_equal "#{@address}, #{@community.city}", @community.address
      end
    end

    context "#nearby_communities" do
      setup do
        @city = City.make
        @communities = []

        3.times do |i|
          @communities << Community.make(:latitude => i, :longitude => i, :city => @city)
        end
      end

      should "return the closest communities" do
        nearby = @communities[0].nearby_communities
        assert_equal 2, nearby.length
        assert_equal @communities[1], nearby[0]
        assert_equal @communities[2], nearby[1]
      end
    end


    context 'with no Yelp Feed' do
      should 'return an empty array on #local_reviews' do
        assert_nil @community.yelp_feed
        assert_equal [], @community.local_reviews
      end
    end

    context 'with a Yelp Feed' do
      setup do
        @feed = YelpFeed.make
        3.times { @feed.items << YelpFeedItem.make }
        @community.yelp_feed = @feed
        @community.save
      end

      should 'return the feed items on #local_reviews' do
        assert_equal 3, @community.local_reviews.length

        3.times do |i|
          assert_equal @feed.items[i], @community.local_reviews[i]
        end
      end
    end
  end
end
