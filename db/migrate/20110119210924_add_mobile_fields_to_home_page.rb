class AddMobileFieldsToHomePage < ActiveRecord::Migration
  def self.up
    add_column :home_pages, :mobile_title, :string
    add_column :home_pages, :mobile_banner_image_file_name, :string
    add_column :home_pages, :mobile_banner_image_content_type, :string
    add_column :home_pages, :mobile_body, :text
  end

  def self.down
    add_column :home_pages, :mobile_title
    add_column :home_pages, :mobile_banner_image_file_name
    add_column :home_pages, :mobile_banner_image_content_type
    add_column :home_pages, :mobile_body
  end
end
