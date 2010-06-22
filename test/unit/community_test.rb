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

    should_validate_presence_of :title, :city
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

    context '#typus_name' do
      should 'return the title' do
        assert_equal @community.title, @community.typus_name
      end
    end

    context '#county' do
      setup do
        @county = County.make
        @community = Community.make(:city => City.make(:county => @county))
      end

      should "return the city's county" do
        assert_equal @county, @community.county
      end
    end

    context '#state' do
      setup do
        @state = State.make
        @community = Community.make(:city => City.make(:state => @state))
      end

      should "return the city's state" do
        assert_equal @state, @community.state
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

      should 'return false on #has_local_reviews?' do
        assert !@community.has_local_reviews?
      end
    end

    context 'with a Yelp Feed' do
      setup do
        @feed = YelpFeed.make_unsaved
        @feed.expects(:validate_on_create)
        @feed.save

        3.times { YelpFeedItem.make :yelp_feed => @feed }
        @community.yelp_feed = @feed
        @community.save
      end

      should 'return the feed items on #local_reviews' do
        assert_equal 3, @community.local_reviews.length

        3.times do |i|
          assert_equal @feed.items[i], @community.local_reviews[i]
        end
      end

      should 'return true on #has_local_reviews?' do
        assert @community.has_local_reviews?
      end
    end
  end
end
