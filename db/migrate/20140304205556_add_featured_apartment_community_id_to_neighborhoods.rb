class AddFeaturedApartmentCommunityIdToNeighborhoods < ActiveRecord::Migration
  def self.up
    add_column :neighborhoods, :featured_apartment_community_id, :integer
  end

  def self.down
    remove_column :neighborhoods, :featured_apartment_community_id
  end
end
