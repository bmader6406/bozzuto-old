class AddIndexesToApartmentFloorPlans < ActiveRecord::Migration
  def self.up
    add_index :apartment_floor_plans, :floor_plan_group_id
    add_index :apartment_floor_plans, :apartment_community_id
  end

  def self.down
    remove_index :apartment_floor_plans, :apartment_community_id
    remove_index :apartment_floor_plans, :floor_plan_group_id
  end
end
