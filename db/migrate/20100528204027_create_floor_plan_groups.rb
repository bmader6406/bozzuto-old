class CreateFloorPlanGroups < ActiveRecord::Migration
  def self.up
    create_table :floor_plan_groups do |t|
      t.with_options :null => false do |n|
        n.string :name
        n.integer :community_id
      end

      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :floor_plan_groups
  end
end
