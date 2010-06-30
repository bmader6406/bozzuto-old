class CreateHomeFloorPlans < ActiveRecord::Migration
  def self.up
    create_table :home_floor_plans do |t|
      t.with_options :null => false do |n|
        n.string :name
        n.string :image_file_name
        n.integer :home_id
      end

      t.string :image_content_type

      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :home_floor_plans
  end
end
