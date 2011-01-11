class RemoveOldFeaturesColumnsFromProperties < ActiveRecord::Migration
  def self.up
    remove_column :properties, :features_1_text
    remove_column :properties, :features_1_title
    remove_column :properties, :features_2_title
    remove_column :properties, :features_2_text
    remove_column :properties, :features_3_title
    remove_column :properties, :features_3_text
    remove_column :properties, :features_meta_title
    remove_column :properties, :features_meta_description
    remove_column :properties, :features_meta_keywords
  end

  def self.down
    add_column :properties, :features_meta_keywords, :string
    add_column :properties, :features_meta_description, :string
    add_column :properties, :features_meta_title, :string
    add_column :properties, :features_3_text, :text
    add_column :properties, :features_3_title, :string
    add_column :properties, :features_2_text, :text
    add_column :properties, :features_2_title, :string
    add_column :properties, :features_1_title, :string
    add_column :properties, :features_1_text, :text
  end
end
