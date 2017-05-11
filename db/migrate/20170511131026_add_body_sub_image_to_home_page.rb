class AddBodySubImageToHomePage < ActiveRecord::Migration
  def change
    add_column :home_pages, :body_sub_image_file_name, :string
    add_column :home_pages, :body_sub_image_content_type, :string
  end
end
