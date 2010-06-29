class ChangeFloorPlanFields < ActiveRecord::Migration
  def self.up
    add_column :floor_plans, :apartment_community_id, :integer, :null => false
    add_column :floor_plans, :min_rent, :decimal, :precision => 6, :scale => 2, :null => false
    add_column :floor_plans, :max_rent, :decimal, :precision => 6, :scale => 2, :null => false
  end

  def self.down
    remove_column :floor_plans, :apartment_community_id
    remove_column :floor_plans, :min_rent
    remove_column :floor_plans, :max_rent
  end
end
