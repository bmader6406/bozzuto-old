class AddLocalInfoFeedToLandingPage < ActiveRecord::Migration
  def self.up
    add_column :landing_pages, :local_info_feed_id, :integer
  end

  def self.down
    remove_column :landing_pages, :local_info_feed_id
  end
end
