class AddListingImageToProperty < ActiveRecord::Migration
  def self.up
    add_column :properties, :listing_image_file_name, :string
    add_column :properties, :listing_image_content_type, :string
  end

  def self.down
    remove_column :properties, :listing_image_file_name
    remove_column :properties, :listing_image_content_type
  end
end
