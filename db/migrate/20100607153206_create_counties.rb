class CreateCounties < ActiveRecord::Migration
  def self.up
    create_table :counties do |t|
      t.string :name, :null => false
      t.integer :state_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :counties
  end
end
