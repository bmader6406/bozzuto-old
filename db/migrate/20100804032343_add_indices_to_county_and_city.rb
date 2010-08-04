class AddIndicesToCountyAndCity < ActiveRecord::Migration
  def self.up
    add_index :cities, :state_id
    add_index :counties, :state_id
  end

  def self.down
    remove_index :cities, :state_id
    remove_index :counties, :state_id
  end
end
