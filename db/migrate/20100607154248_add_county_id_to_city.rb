class AddCountyIdToCity < ActiveRecord::Migration
  def self.up
    add_column :cities, :county_id, :integer
  end

  def self.down
    remove_column :cities, :county_id
  end
end
