class CreateFloorPlans < ActiveRecord::Migration
  def self.up
    create_table :floor_plans do |t|
      t.with_options :null => false do |n|
        n.string :image
        n.string :category
        n.integer :bedrooms
        n.decimal :bathrooms, :precision => 3, :scale => 1
        n.integer :square_feet
        n.integer :price
        n.integer :community_id
      end
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :floor_plans
  end
end
