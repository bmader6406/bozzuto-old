class AddAvailableUnitsToApartmentFloorPlans < ActiveRecord::Migration
  def self.up
    add_column :apartment_floor_plans, :available_units, :integer, :default => 0
  end

  def self.down
    remove_column :apartment_floor_plans, :available_units
  end
end
