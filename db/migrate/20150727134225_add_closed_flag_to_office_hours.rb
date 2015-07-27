class AddClosedFlagToOfficeHours < ActiveRecord::Migration
  def self.up
    add_column :office_hours, :closed, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :office_hours, :closed
  end
end
