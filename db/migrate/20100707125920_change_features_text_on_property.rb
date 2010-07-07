class ChangeFeaturesTextOnProperty < ActiveRecord::Migration
  def self.up
    rename_column :properties, :features_text, :features_1_text

    add_column :properties, :features_1_title, :string

    add_column :properties, :features_2_title, :string
    add_column :properties, :features_2_text, :text
    add_column :properties, :features_3_title, :string
    add_column :properties, :features_3_text, :text
  end

  def self.down
    rename_column :properties, :features_1_text, :features_text

    remove_column :properties, :features_1_title
    remove_column :properties, :features_2_title
    remove_column :properties, :features_2_text
    remove_column :properties, :features_3_title
    remove_column :properties, :features_3_text
  end
end
