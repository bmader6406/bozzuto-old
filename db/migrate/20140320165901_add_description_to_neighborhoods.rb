class AddDescriptionToNeighborhoods < ActiveRecord::Migration
  def self.up
    add_column :metros,        :description, :text
    add_column :areas,         :description, :text
    add_column :neighborhoods, :description, :text
  end

  def self.down
    remove_column :metros,        :description
    remove_column :areas,         :description
    remove_column :neighborhoods, :description
  end
end
