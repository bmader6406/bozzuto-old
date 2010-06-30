class CreatePropertySlides < ActiveRecord::Migration
  def self.up
    create_table :property_slides do |t|
      t.text    :caption
      t.string  :image_file_name, :null => false
      t.string  :image_content_type, :null => false
      t.integer :position
      t.integer :property_slideshow_id

      t.timestamps
    end
  end

  def self.down
    drop_table :property_slides
  end
end
