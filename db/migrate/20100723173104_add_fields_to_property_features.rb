class AddFieldsToPropertyFeatures < ActiveRecord::Migration
  def self.up
    add_column :property_features, :show_on_search_page, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :property_features, :show_on_search_page
  end
end
