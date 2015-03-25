class AddCoreIdToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :core_id, :integer
    add_index  :properties, :core_id
  end

  def self.down
    remove_index  :properties, :core_id
    remove_column :properties, :core_id
  end
end
