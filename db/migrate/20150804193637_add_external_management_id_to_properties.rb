class AddExternalManagementIdToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :external_management_id, :string
  end

  def self.down
    remove_column :properties, :external_management_id
  end
end
