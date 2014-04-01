class AddStateIdToAreas < ActiveRecord::Migration
  def self.up
    add_column :areas, :state_id, :integer
  end

  def self.down
    remove_column :areas, :state_id
  end
end
