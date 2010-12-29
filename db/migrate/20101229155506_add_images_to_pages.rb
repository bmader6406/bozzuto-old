class AddImagesToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :left_montage_image_file_name, :string
    add_column :pages, :middle_montage_image_file_name, :string
    add_column :pages, :right_montage_image_file_name, :string
  end

  def self.down
    remove_column :pages, :right_montage_image_file_name
    remove_column :pages, :middle_montage_image_file_name
    remove_column :pages, :left_montage_image_file_name
  end
end