class RemoveOldContactColumnsFromProperties < ActiveRecord::Migration
  def self.up
    remove_column :properties, :contact_text
    remove_column :properties, :contact_meta_title
    remove_column :properties, :contact_meta_description
    remove_column :properties, :contact_meta_keywords
  end

  def self.down
    add_column :properties, :contact_meta_keywords, :string
    add_column :properties, :contact_meta_description, :string
    add_column :properties, :contact_meta_title, :string
    add_column :properties, :contact_text, :text
  end
end
