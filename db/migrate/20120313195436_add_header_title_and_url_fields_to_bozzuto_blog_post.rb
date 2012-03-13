class AddHeaderTitleAndUrlFieldsToBozzutoBlogPost < ActiveRecord::Migration
  def self.up
    add_column :bozzuto_blog_posts, :header_title, :string
    add_column :bozzuto_blog_posts, :header_url, :string
  end

  def self.down
    remove_column :bozzuto_blog_posts, :header_title
    remove_column :bozzuto_blog_posts, :header_url
  end
end
