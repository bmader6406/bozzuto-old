class CreateTomsBlogPosts < ActiveRecord::Migration
  def self.up
    create_table :toms_blog_posts do |t|
      t.string :title
      t.string :url
      t.string :image_file_name
      t.string :image_content_type
      t.datetime :published_at

      t.timestamps
    end

    add_index :toms_blog_posts, :published_at
  end

  def self.down
    drop_table :toms_blog_posts
  end
end
