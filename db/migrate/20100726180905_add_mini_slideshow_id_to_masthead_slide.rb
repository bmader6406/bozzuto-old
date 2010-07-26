class AddMiniSlideshowIdToMastheadSlide < ActiveRecord::Migration
  def self.up
    remove_column :masthead_slides, :featured_property_id
    add_column :masthead_slides, :mini_slideshow_id, :integer
  end

  def self.down
    add_column :masthead_slides, :featured_property_id, :integer
    remove_column :masthead_slides, :mini_slideshow_id
  end
end
