class CreateYelpFeeds < ActiveRecord::Migration
  def self.up
    create_table :yelp_feeds do |t|
      t.string :url, :null => false
      t.datetime :fetched_at

      t.timestamps
    end
  end

  def self.down
    drop_table :yelp_feeds
  end
end
