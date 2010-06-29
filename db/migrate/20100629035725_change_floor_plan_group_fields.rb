class ChangeFloorPlanGroupFields < ActiveRecord::Migration
  def self.up
    remove_column :floor_plan_groups, :apartment_community_id

    FloroPlan.all.each { |plan| plan.delete }
    FloorPlanGroup.all.each { |group| group.delete }

    FloorPlanGroup.create :name => 'Studio'
    FloorPlanGroup.create :name => '1 Bedroom'
    FloorPlanGroup.create :name => '2 Bedrooms'
    FloorPlanGroup.create :name => '3 or More Bedrooms'
    FloorPlanGroup.create :name => 'Penthouse'
  end

  def self.down
    add_column :floor_plan_groups, :apartment_community_id, :integer, :null => false
  end
end
