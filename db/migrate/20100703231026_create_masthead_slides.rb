class CreateMastheadSlides < ActiveRecord::Migration
  def self.up
    create_table :masthead_slides do |t|
      t.text :body, :null => false

      t.integer :slide_type, :default => 0, :null => false

      t.string :image_file_name
      t.string :image_content_type
      t.string :image_link

      t.text :sidebar_text

      t.integer :featured_property_id

      t.integer :masthead_slideshow_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :masthead_slides
  end
end
