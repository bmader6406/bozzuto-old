class AddNeighborhoodImageAndDescriptionToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :neighborhood_description, :text
    add_column :properties, :neighborhood_listing_image_file_name, :string
  end

  def self.down
    remove_column :properties, :neighborhood_description
    remove_column :properties, :neighborhood_listing_image_file_name
  end
end
