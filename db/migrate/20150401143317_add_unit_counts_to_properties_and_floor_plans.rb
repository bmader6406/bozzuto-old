class AddUnitCountsToPropertiesAndFloorPlans < ActiveRecord::Migration
  def self.up
    add_column :properties,            :unit_count, :integer
    add_column :apartment_floor_plans, :unit_count, :integer
  end

  def self.down
    remove_column :properties,            :unit_count, :integer
    remove_column :apartment_floor_plans, :unit_count, :integer
  end
end
