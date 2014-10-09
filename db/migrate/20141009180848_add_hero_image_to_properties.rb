class AddHeroImageToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :hero_image_file_name,    :string
    add_column :properties, :hero_image_content_type, :string
    add_column :properties, :hero_image_file_size,    :integer
  end

  def self.down
    remove_column :properties, :hero_image_file_name
    remove_column :properties, :hero_image_content_type
    remove_column :properties, :hero_image_file_size
  end
end
