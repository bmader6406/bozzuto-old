class RemoveSecondSlideshowFromHomePage < ActiveRecord::Migration
  def self.up
    remove_column :home_pages, :home_mini_slideshow_id
    rename_column :home_pages, :apartment_mini_slideshow_id, :mini_slideshow_id
  end

  def self.down
    rename_column :home_pages, :mini_slideshow_id, :apartment_mini_slideshow_id
    add_column :home_pages, :home_mini_slideshow_id, :integer
  end
end
