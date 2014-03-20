class AddApartmentCommunitiesCountCacheToPlaces < ActiveRecord::Migration
  def self.up
    add_column :metros,        :apartment_communities_count, :integer, :default => 0
    add_column :areas,         :apartment_communities_count, :integer, :default => 0
    add_column :neighborhoods, :apartment_communities_count, :integer, :default => 0

    add_index :metros,        :apartment_communities_count
    add_index :areas,         :apartment_communities_count
    add_index :neighborhoods, :apartment_communities_count
  end

  def self.down
    remove_column :metros,        :apartment_communities_count
    remove_column :areas,         :apartment_communities_count
    remove_column :neighborhoods, :apartment_communities_count
  end
end
