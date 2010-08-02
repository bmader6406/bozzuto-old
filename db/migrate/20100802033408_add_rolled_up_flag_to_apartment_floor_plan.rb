class AddRolledUpFlagToApartmentFloorPlan < ActiveRecord::Migration
  def self.up
    add_column :apartment_floor_plans, :rolled_up, :boolean,
      :default => false,
      :null    => false
  end

  def self.down
    remove_column :apartment_floor_plans, :rolled_up
  end
end
