class ChangePropertyMiniSlideshowToMiniSlideshow < ActiveRecord::Migration
  def self.up
    rename_table :property_mini_slideshows, :mini_slideshows
    rename_column :mini_slideshows, :name, :title
    add_column :mini_slideshows, :subtitle, :string
    add_column :mini_slideshows, :link_url, :string
    remove_column :mini_slideshows, :property_id

    rename_table :property_mini_slides, :mini_slides
    rename_column :mini_slides, :property_mini_slideshow_id, :mini_slideshow_id
  end

  def self.down
    rename_table :mini_slideshows, :property_mini_slideshows
    rename_column :property_mini_slideshows, :title, :name
    remove_column :property_mini_slideshows, :subtitle
    remove_column :property_mini_slideshows, :link_url
    add_column :property_mini_slideshows, :property_id, :integer

    rename_table :mini_slides, :property_mini_slides
    rename_column :property_mini_slides, :mini_slideshow_id, :property_mini_slideshow_id
  end
end
