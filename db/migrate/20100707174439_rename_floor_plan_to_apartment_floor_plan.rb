class RenameFloorPlanToApartmentFloorPlan < ActiveRecord::Migration
  def self.up
    rename_table :floor_plans, :apartment_floor_plans
  end

  def self.down
    rename_table :apartment_floor_plans, :floor_plans
  end
end
