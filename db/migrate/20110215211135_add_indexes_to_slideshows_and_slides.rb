class AddIndexesToSlideshowsAndSlides < ActiveRecord::Migration
  def self.up
    add_index :home_pages, :mini_slideshow_id

    add_index :body_slideshows, :page_id
    add_index :body_slides, :body_slideshow_id

    add_index :masthead_slideshows, :page_id
    add_index :masthead_slides, :masthead_slideshow_id
    add_index :masthead_slides, :mini_slideshow_id

    add_index :mini_slides, :mini_slideshow_id

    add_index :property_slideshows, :property_id
    add_index :property_slides, :property_slideshow_id
  end

  def self.down
    remove_index :home_pages, :mini_slideshow_id

    remove_index :body_slideshows, :page_id
    remove_index :body_slides, :body_slideshow_id

    remove_index :masthead_slideshows, :page_id
    remove_index :masthead_slides, :masthead_slideshow_id
    remove_index :masthead_slides, :mini_slideshow_id

    remove_index :mini_slides, :mini_slideshow_id

    remove_index :property_slideshows, :property_id
    remove_index :property_slides, :property_slideshow_id
  end
end
