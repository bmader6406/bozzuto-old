class CreateYelpFeedItems < ActiveRecord::Migration
  def self.up
    create_table :yelp_feed_items do |t|
      t.integer :yelp_feed_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :yelp_feed_items
  end
end
