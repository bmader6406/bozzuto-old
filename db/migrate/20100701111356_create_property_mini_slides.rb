class CreatePropertyMiniSlides < ActiveRecord::Migration
  def self.up
    create_table :property_mini_slides do |t|
      t.string  :image_file_name, :null => false
      t.string  :image_content_type, :null => false
      t.integer :position
      t.integer :property_mini_slideshow_id

      t.timestamps
    end
  end

  def self.down
    drop_table :property_mini_slides
  end
end
