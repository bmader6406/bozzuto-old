class AddIncludeInExportFlagToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :included_in_export, :boolean, :default => false, :null => false
    add_index  :properties, :included_in_export

    ApartmentCommunity.published.each { |community| community.update_attribute(:included_in_export, true) }
  end

  def self.down
    remove_column :properties, :included_in_export
  end
end
