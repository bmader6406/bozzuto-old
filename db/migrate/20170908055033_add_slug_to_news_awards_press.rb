class AddSlugToNewsAwardsPress < ActiveRecord::Migration
  def self.up
    add_column :news_posts, :slug, :string, :unique => true
    add_column :awards, :slug, :string, :unique => true
    add_column :press_releases, :slug, :string, :unique => true

    add_index :news_posts, :slug
    add_index :awards, :slug
    add_index :press_releases, :slug
  end

  def self.down
    remove_column :news_posts, :slug
    remove_column :awards, :slug
    remove_column :press_releases, :slug
  end
end
