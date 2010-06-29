class AddCountyIdToProperty < ActiveRecord::Migration
  def self.up
    add_column :properties, :county_id, :integer
  end

  def self.down
    remove_column :properties, :county_id, :integer
  end
end
