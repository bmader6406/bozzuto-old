class EnhancePrecisionOfLatLongOnProperties < ActiveRecord::Migration
  def self.up
    change_column :properties, :latitude,  :decimal, precision: 10, scale: 6
    change_column :properties, :longitude, :decimal, precision: 10, scale: 6
  end

  def self.down
    change_column :properties, :latitude,  :decimal, precision: 8, scale: 4
    change_column :properties, :longitude, :decimal, precision: 8, scale: 4
  end
end
