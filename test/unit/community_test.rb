require 'test_helper'

class CommunityTest < ActiveSupport::TestCase
  context 'Community' do
    setup do
      @community = Community.new
    end

    subject { @community }

    should_belong_to :local_info_feed

    context '#has_overview_bullets?' do
      should 'return false if all bullets are empty' do
        (1..3).each do |i|
          assert_nil @community.send("overview_bullet_#{i}")
        end
        assert !@community.has_overview_bullets?
      end

      should 'return true if any bullets are present' do
        @community.overview_bullet_2 = 'Blah blah blah'
        assert @community.has_overview_bullets?
      end
    end

    context 'with no Feed' do
      should 'return an empty array on #local_info' do
        assert_nil @community.local_info_feed
        assert_equal [], @community.local_info
      end

      should 'return false on #has_local_reviews?' do
        assert !@community.has_local_info?
      end
    end

    context 'with a Yelp Feed' do
      setup do
        @feed = Feed.make_unsaved
        @feed.expects(:validate_on_create)
        @feed.save

        3.times { FeedItem.make :feed => @feed }
        @community.local_info_feed = @feed
        @community.save
      end

      should 'return the feed items on #local_info' do
        assert_equal 3, @community.local_info.length

        3.times do |i|
          assert_equal @feed.items[i], @community.local_info[i]
        end
      end

      should 'return true on #has_local_info?' do
        assert @community.has_local_info?
      end
    end
  end
end
