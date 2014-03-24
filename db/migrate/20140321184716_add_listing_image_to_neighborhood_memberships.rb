class AddListingImageToNeighborhoodMemberships < ActiveRecord::Migration
  def self.up
    add_column :neighborhood_memberships, :listing_image_file_name, :string, :null => false
  end

  def self.down
    remove_column :neighborhood_memberships, :listing_image_file_name
  end
end
