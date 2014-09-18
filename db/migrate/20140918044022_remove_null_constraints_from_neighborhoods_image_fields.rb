class RemoveNullConstraintsFromNeighborhoodsImageFields < ActiveRecord::Migration
  def self.up
    change_column :areas,         :listing_image_file_name, :string, :null => true
    change_column :neighborhoods, :listing_image_file_name, :string, :null => true
    change_column :neighborhoods, :banner_image_file_name,  :string, :null => true
  end

  def self.down
    change_column :areas,         :listing_image_file_name, :string, :null => false
    change_column :neighborhoods, :listing_image_file_name, :string, :null => false
    change_column :neighborhoods, :banner_image_file_name,  :string, :null => false
  end
end
