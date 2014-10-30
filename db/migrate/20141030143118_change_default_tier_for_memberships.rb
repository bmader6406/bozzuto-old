class ChangeDefaultTierForMemberships < ActiveRecord::Migration
  def self.up
    change_column :neighborhood_memberships, :tier, :integer, default: 2
    change_column :area_memberships,         :tier, :integer, default: 2
  end

  def self.down
    change_column :neighborhood_memberships, :tier, :integer, default: 1
    change_column :area_memberships,         :tier, :integer, default: 1
  end
end
