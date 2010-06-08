class CreateYelpFeedItems < ActiveRecord::Migration
  def self.up
    create_table :yelp_feed_items do |t|
      t.with_options :null => false do |n|
        n.string :title
        n.string :url
        n.string :description
        n.datetime :published_at
        n.integer :yelp_feed_id
      end

      t.timestamps
    end
  end

  def self.down
    drop_table :yelp_feed_items
  end
end
