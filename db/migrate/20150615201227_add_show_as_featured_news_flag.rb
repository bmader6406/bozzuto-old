class AddShowAsFeaturedNewsFlag < ActiveRecord::Migration
  def self.up
    add_column :news_posts,     :show_as_featured_news, :boolean, :null => false, :default => false
    add_column :awards,         :show_as_featured_news, :boolean, :null => false, :default => false
    add_column :press_releases, :show_as_featured_news, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :news_posts,     :show_as_featured_news
    remove_column :awards,         :show_as_featured_news
    remove_column :press_releases, :show_as_featured_news
  end
end
