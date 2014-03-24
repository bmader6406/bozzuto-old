class AddDetailDescriptionToPlaces < ActiveRecord::Migration
  def self.up
    add_column :metros,        :detail_description, :text
    add_column :areas,         :detail_description, :text
    add_column :neighborhoods, :detail_description, :text
  end

  def self.down
    remove_column :metros,        :detail_description
    remove_column :areas,         :detail_description
    remove_column :neighborhoods, :detail_description
  end
end
