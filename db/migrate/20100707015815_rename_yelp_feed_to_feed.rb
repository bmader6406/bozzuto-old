class RenameYelpFeedToFeed < ActiveRecord::Migration
  def self.up
    rename_table :yelp_feeds, :feeds
    rename_table :yelp_feed_items, :feed_items

    rename_column :feed_items, :yelp_feed_id, :feed_id
    rename_column :properties, :yelp_feed_id, :local_info_feed_id
  end

  def self.down
    rename_column :properties, :local_info_feed_id, :yelp_feed_id
    rename_column :feed_items, :feed_id, :yelp_feed_id

    rename_table :feed_items, :yelp_feed_items
    rename_table :feeds, :yelp_feeds
  end
end
