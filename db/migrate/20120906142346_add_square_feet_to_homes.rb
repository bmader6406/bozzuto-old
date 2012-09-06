class AddSquareFeetToHomes < ActiveRecord::Migration
  def self.up
    add_column :homes, :square_feet, :integer
  end

  def self.down
    remove_column :homes, :square_feet
  end
end
