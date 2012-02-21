class AddHomePageImageToNewsPost < ActiveRecord::Migration
  def self.up
    add_column :news_posts, :home_page_image_file_name, :string
    add_column :news_posts, :home_page_image_content_type, :string
  end

  def self.down
    remove_column :news_posts, :home_page_image_file_name
    remove_column :news_posts, :home_page_image_content_type
  end
end
