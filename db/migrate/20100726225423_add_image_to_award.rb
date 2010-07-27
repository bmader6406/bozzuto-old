class AddImageToAward < ActiveRecord::Migration
  def self.up
    add_column :awards, :image_file_name, :string
    add_column :awards, :image_content_type, :string
  end

  def self.down
    remove_column :awards, :image_file_name
    remove_column :awards, :image_content_type
  end
end
