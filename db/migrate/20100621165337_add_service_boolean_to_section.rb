class AddServiceBooleanToSection < ActiveRecord::Migration
  def self.up
    add_column :sections, :service, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :sections, :service
  end
end
