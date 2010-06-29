class AddMontageImagesToSection < ActiveRecord::Migration
  def self.up
    add_column :sections, :left_montage_image_file_name, :string
    add_column :sections, :middle_montage_image_file_name, :string
    add_column :sections, :right_montage_image_file_name, :string
  end

  def self.down
    remove_column :sections, :left_montage_image_file_name
    remove_column :sections, :middle_montage_image_file_name
    remove_column :sections, :right_montage_image_file_name
  end
end
