class RemoveSectionAndCategoryFromNewsPost < ActiveRecord::Migration
  def self.up
    remove_column :news_posts, :section_id
    remove_column :news_posts, :category
  end

  def self.down
    add_column :news_posts, :section_id, :integer, :null => false
    add_column :news_posts, :category, :string
  end
end
