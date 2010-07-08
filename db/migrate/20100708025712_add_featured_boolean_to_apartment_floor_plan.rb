class AddFeaturedBooleanToApartmentFloorPlan < ActiveRecord::Migration
  def self.up
    add_column :apartment_floor_plans, :featured, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :apartment_floor_plans, :featured
  end
end
