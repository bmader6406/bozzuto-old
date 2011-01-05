class AddHideFromListToLandingPages < ActiveRecord::Migration
  def self.up
    add_column :landing_pages, :hide_from_list, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :landing_pages, :hide_from_list
  end
end
