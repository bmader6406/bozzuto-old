class CreatePropertyRetailSlides < ActiveRecord::Migration
  def self.up
    create_table :property_retail_slides do |t|
      t.string  :name,               :null => false
      t.string  :image_file_name,    :null => false
      t.string  :image_content_type, :null => false
      t.string  :caption
      t.string  :video_url
      t.string  :link_url
      t.integer :position
      t.integer :property_retail_page_id

      t.timestamps
    end
  end

  def self.down
    drop_table :property_retail_slides
  end
end
