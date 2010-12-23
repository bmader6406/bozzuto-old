class AddCustomSortPopularPropertiesToLandingPages < ActiveRecord::Migration
  def self.up
    add_column :landing_pages, :custom_sort_popular_properties, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :landing_pages, :custom_sort_popular_properties
  end
end