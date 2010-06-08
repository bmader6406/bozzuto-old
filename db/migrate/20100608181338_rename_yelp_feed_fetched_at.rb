class RenameYelpFeedFetchedAt < ActiveRecord::Migration
  def self.up
    rename_column :yelp_feeds, :fetched_at, :refreshed_at
  end

  def self.down
    rename_column :yelp_feeds, :refreshed_at, :fetched_at
  end
end
