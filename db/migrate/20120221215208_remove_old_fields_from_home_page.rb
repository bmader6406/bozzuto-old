class RemoveOldFieldsFromHomePage < ActiveRecord::Migration
  def self.up
    remove_column :home_pages, :mini_slideshow_id
    remove_column :home_pages, :twitter_account_id
  end

  def self.down
    add_column :home_pages, :mini_slideshow_id, :integer
    add_column :home_pages, :twitter_account_id, :integer
  end
end
