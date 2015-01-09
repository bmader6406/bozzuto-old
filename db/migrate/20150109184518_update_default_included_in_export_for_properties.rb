class UpdateDefaultIncludedInExportForProperties < ActiveRecord::Migration
  def self.up
    change_column :properties, :included_in_export, :boolean, :default => true, :null => false
  end

  def self.down
    change_column :properties, :included_in_export, :boolean, :default => false, :null => false
  end
end
