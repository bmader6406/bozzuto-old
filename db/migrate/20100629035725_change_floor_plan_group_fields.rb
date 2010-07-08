class ChangeFloorPlanGroupFields < ActiveRecord::Migration
  def self.up
    remove_column :floor_plan_groups, :apartment_community_id
  end

  def self.down
    add_column :floor_plan_groups, :apartment_community_id, :integer, :null => false
  end
end
