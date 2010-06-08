require 'test_helper'

class YelpFeedItemTest < ActiveSupport::TestCase
  context 'A YelpFeedItem' do
    should_belong_to :yelp_feed

    should_validate_presence_of :title,
      :url,
      :description,
      :published_at,
      :yelp_feed

    should 'order from newest to oldest by default' do
      @feed = YelpFeed.make
      @item1 = YelpFeedItem.make :published_at => Time.now,
        :yelp_feed => @feed
      @item2 = YelpFeedItem.make :published_at => Time.now - 1.day,
        :yelp_feed => @feed

      assert_equal @item1, @feed.items[0]
      assert_equal @item2, @feed.items[1]
    end
  end
end
