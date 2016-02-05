class RemoveCommunityCounts < ActiveRecord::Migration
  def change
    remove_column :areas,              :apartment_communities_count, :integer, default: 0
    remove_column :metros,             :apartment_communities_count, :integer, default: 0
    remove_column :neighborhoods,      :apartment_communities_count, :integer, default: 0
    remove_column :home_neighborhoods, :home_communities_count,      :integer, default: 0
  end
end
