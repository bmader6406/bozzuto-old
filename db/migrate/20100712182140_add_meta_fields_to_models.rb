class AddMetaFieldsToModels < ActiveRecord::Migration
  TABLES = %w(pages news_posts properties home_pages)

  def self.up
    TABLES.each do |table|
      add_column table, :meta_title, :string
      add_column table, :meta_description, :string
      add_column table, :meta_keywords, :string
    end
  end

  def self.down
    TABLES.each do |table|
      remove_column table, :meta_title
      remove_column table, :meta_description
      remove_column table, :meta_keywords
    end
  end
end
