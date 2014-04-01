class AddAreaTypeToAreas < ActiveRecord::Migration
  def self.up
    add_column :areas, :area_type, :string, :null => false, :default => 'neighborhoods'
  end

  def self.down
    remove_column :areas, :area_type
  end
end
