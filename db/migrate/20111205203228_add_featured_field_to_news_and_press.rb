class AddFeaturedFieldToNewsAndPress < ActiveRecord::Migration
  def self.up
    add_column :awards, :featured, :boolean, :default => false
    add_column :news_posts, :featured, :boolean, :default => false
    add_column :press_releases, :featured, :boolean, :default => false
  end

  def self.down
    remove_column :awards, :featured
    remove_column :news_posts, :featured
    remove_column :press_releases, :featured
  end
end
