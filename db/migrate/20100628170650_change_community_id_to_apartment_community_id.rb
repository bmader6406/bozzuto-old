class ChangeCommunityIdToApartmentCommunityId < ActiveRecord::Migration
  def self.up
    rename_column :floor_plan_groups, :community_id, :apartment_community_id
    rename_column :photos, :community_id, :apartment_community_id
  end

  def self.down
    rename_column :floor_plan_groups, :apartment_community_id, :community_id
    rename_column :photos, :apartment_community_id, :community_id
  end
end
