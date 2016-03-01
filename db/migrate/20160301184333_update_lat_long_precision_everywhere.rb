class UpdateLatLongPrecisionEverywhere < ActiveRecord::Migration
  def self.up
    change_column :areas,              :latitude,  :decimal, precision: 10, scale: 6, null: false
    change_column :areas,              :longitude, :decimal, precision: 10, scale: 6, null: false
    change_column :home_neighborhoods, :latitude,  :decimal, precision: 10, scale: 6, null: false
    change_column :home_neighborhoods, :longitude, :decimal, precision: 10, scale: 6, null: false
    change_column :metros,             :latitude,  :decimal, precision: 10, scale: 6, null: false
    change_column :metros,             :longitude, :decimal, precision: 10, scale: 6, null: false
    change_column :neighborhoods,      :latitude,  :decimal, precision: 10, scale: 6, null: false
    change_column :neighborhoods,      :longitude, :decimal, precision: 10, scale: 6, null: false
  end

  def self.down
    change_column :areas,              :latitude,  :decimal, precision: 8, scale: 4, null: false
    change_column :areas,              :longitude, :decimal, precision: 8, scale: 4, null: false
    change_column :home_neighborhoods, :latitude,  :decimal, precision: 8, scale: 4, null: false
    change_column :home_neighborhoods, :longitude, :decimal, precision: 8, scale: 4, null: false
    change_column :metros,             :latitude,  :decimal, precision: 8, scale: 4, null: false
    change_column :metros,             :longitude, :decimal, precision: 8, scale: 4, null: false
    change_column :neighborhoods,      :latitude,  :decimal, precision: 8, scale: 4, null: false
    change_column :neighborhoods,      :longitude, :decimal, precision: 8, scale: 4, null: false
  end
end
