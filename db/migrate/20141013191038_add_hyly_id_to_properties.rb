class AddHylyIdToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :hyly_id, :string
  end

  def self.down
    remove_column :properties, :hyly_id
  end
end
