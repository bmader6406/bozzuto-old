class CreateLeaderships < ActiveRecord::Migration
  def self.up
    create_table :leaderships do |t|
      t.integer :leader_id,           :null => false
      t.integer :leadership_group_id, :null => false
      t.integer :position

      t.timestamps
    end

    add_index :leaderships, :leader_id
    add_index :leaderships, :leadership_group_id
    add_index :leaderships, [:leader_id, :leadership_group_id], :unique => true
  end

  def self.down
    drop_table :leaderships
  end
end
