class RenameTomsBlogPostsToBozzutoBlogPosts < ActiveRecord::Migration
  def self.up
    remove_index :toms_blog_posts, :published_at

    rename_table :toms_blog_posts, :bozzuto_blog_posts

    add_index :bozzuto_blog_posts, :published_at
  end

  def self.down
    remove_index :bozzuto_blog_posts, :published_at

    rename_table :bozzuto_blog_posts, :toms_blog_posts

    add_index :toms_blog_posts, :published_at
  end
end
