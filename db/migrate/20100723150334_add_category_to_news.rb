class AddCategoryToNews < ActiveRecord::Migration
  def self.up
    add_column :news_posts, :category, :string
    NewsPost.update_all(:category => "Press Releases")
  end

  def self.down
    remove_column :news_posts, :category
  end
end
