class AddPositionToNeighborhoodMemberships < ActiveRecord::Migration
  def self.up
    add_column :neighborhood_memberships, :tier, :integer, null: false, default: 1
    add_index  :neighborhood_memberships, :tier
    add_column :area_memberships,         :tier, :integer, null: false, default: 1
    add_index  :area_memberships,         :tier
  end

  def self.down
    remove_column :neighborhood_memberships, :tier
    remove_column :area_memberships,         :tier
  end
end
