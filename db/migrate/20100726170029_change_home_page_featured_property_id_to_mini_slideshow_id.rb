class ChangeHomePageFeaturedPropertyIdToMiniSlideshowId < ActiveRecord::Migration
  def self.up
    remove_column :home_pages, :featured_property_id
    add_column :home_pages, :mini_slideshow_id, :integer
  end

  def self.down
    add_column :home_pages, :featured_property_id, :integer
    remove_column :home_pages, :mini_slideshow_id
  end
end
