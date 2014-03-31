class RemoveMinAndMaxRentFromProperties < ActiveRecord::Migration
  def self.up
    remove_column :properties, :min_rent
    remove_column :properties, :max_rent
  end

  def self.down
    add_column :properties, :min_rent, :decimal, :precision => 8, :scale => 2
    add_column :properties, :max_rent, :decimal, :precision => 8, :scale => 2
  end
end
