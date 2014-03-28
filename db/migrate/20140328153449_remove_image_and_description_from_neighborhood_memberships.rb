class RemoveImageAndDescriptionFromNeighborhoodMemberships < ActiveRecord::Migration
  def self.up
    remove_column :neighborhood_memberships, :description
    remove_column :neighborhood_memberships, :listing_image_file_name
  end

  def self.down
    add_column :neighborhood_memberships, :description, :text
    add_column :neighborhood_memberships, :listing_image_file_name, :string, :null => false
  end
end
