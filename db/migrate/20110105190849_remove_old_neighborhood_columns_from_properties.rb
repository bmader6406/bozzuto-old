class RemoveOldNeighborhoodColumnsFromProperties < ActiveRecord::Migration
  def self.up
    remove_column :properties, :neighborhood_text
    remove_column :properties, :neighborhood_meta_title
    remove_column :properties, :neighborhood_meta_description
    remove_column :properties, :neighborhood_meta_keywords
  end

  def self.down
    add_column :properties, :neighborhood_meta_keywords, :string
    add_column :properties, :neighborhood_meta_description, :string
    add_column :properties, :neighborhood_meta_title, :string
    add_column :properties, :neighborhood_text, :text
  end
end
