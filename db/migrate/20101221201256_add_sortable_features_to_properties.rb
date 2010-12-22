class AddSortableFeaturesToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :featured, :boolean, :default => false, :null => false
    add_column :properties, :featured_position, :integer
  end

  def self.down
    remove_column :properties, :featured_position
    remove_column :properties, :featured
  end
end