class AddIncludeInExportFlagToApartmentUnits < ActiveRecord::Migration
  def self.up
    add_column :apartment_units, :include_in_export, :boolean, :null => false, :default => true
  end

  def self.down
    remove_column :apartment_units, :include_in_export
  end
end
