class RenameFloorPlanGroupToApartmentFloorPlanGroup < ActiveRecord::Migration
  def self.up
    rename_table :floor_plan_groups, :apartment_floor_plan_groups
  end

  def self.down
    rename_table :apartment_floor_plan_groups, :floor_plan_groups
  end
end
