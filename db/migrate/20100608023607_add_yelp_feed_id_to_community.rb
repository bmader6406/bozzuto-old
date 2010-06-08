class AddYelpFeedIdToCommunity < ActiveRecord::Migration
  def self.up
    add_column :communities, :yelp_feed_id, :integer
  end

  def self.down
    remove_column :communities, :yelp_feed_id
  end
end
