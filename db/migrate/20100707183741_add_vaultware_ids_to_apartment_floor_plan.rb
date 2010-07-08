class AddVaultwareIdsToApartmentFloorPlan < ActiveRecord::Migration
  def self.up
    add_column :apartment_floor_plans, :vaultware_floor_plan_id, :integer
    add_column :apartment_floor_plans, :vaultware_file_id, :integer
  end

  def self.down
    remove_column :apartment_floor_plans, :vaultware_floor_plan_id
    remove_column :apartment_floor_plans, :vaultware_file_id
  end
end
