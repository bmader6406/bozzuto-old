require 'test_helper'

class CommunityTest < ActiveSupport::TestCase
  context 'Community' do
    setup do
      @community = Community.new
    end

    subject { @community }

    should_belong_to :yelp_feed

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
