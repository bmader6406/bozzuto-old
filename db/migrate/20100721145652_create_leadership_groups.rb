class CreateLeadershipGroups < ActiveRecord::Migration
  def self.up
    create_table :leadership_groups do |t|
      t.string :name, :null => false
      t.integer :position
      t.timestamps
    end
  end

  def self.down
    drop_table :leadership_groups
  end
end
