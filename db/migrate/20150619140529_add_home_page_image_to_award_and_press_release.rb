class AddHomePageImageToAwardAndPressRelease < ActiveRecord::Migration
  def self.up
    add_column :awards, :home_page_image_file_name, :string
    add_column :awards, :home_page_image_content_type, :string

    add_column :press_releases, :home_page_image_file_name, :string
    add_column :press_releases, :home_page_image_content_type, :string
  end

  def self.down
    remove_column :awards, :home_page_image_file_name
    remove_column :awards, :home_page_image_content_type

    remove_column :press_releases, :home_page_image_file_name
    remove_column :press_releases, :home_page_image_content_type
  end
end
