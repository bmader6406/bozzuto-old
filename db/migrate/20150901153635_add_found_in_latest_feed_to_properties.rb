class AddFoundInLatestFeedToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :found_in_latest_feed, :boolean, :null => false, :default => true
  end

  def self.down
    remove_column :properties, :found_in_latest_feed
  end
end
