require 'test_helper'

class FeedItemTest < ActiveSupport::TestCase
  context 'FeedItem' do
    should_belong_to :feed

    should_validate_presence_of :title,
      :url,
      :description,
      :published_at,
      :feed

    should 'order from newest to oldest by default' do
      @feed = Feed.make_unsaved
      @feed.expects(:valid_feed)
      @feed.save

      @item1 = FeedItem.make :published_at => Time.now, :feed => @feed
      @item2 = FeedItem.make :published_at => Time.now - 1.day, :feed => @feed

      assert_equal @item1, @feed.items[0]
      assert_equal @item2, @feed.items[1]
    end
  end

  context 'The FeedItem class' do
    context 'when searching for recent items' do
      setup do
        @feed = Feed.make_unsaved
        @feed.expects(:valid_feed)
        @feed.save

        @items = (1..15).inject([]) do |array, i|
          array << FeedItem.make(
            :published_at => Time.now - i.days,
            :feed         => @feed
          )
        end
      end

      should 'return the 10 most recent' do
        assert_equal @items.take(10), @feed.items.recent
      end
    end
  end
end
