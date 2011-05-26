class AddShowApartmentsByAreaBooleanToLandingPages < ActiveRecord::Migration
  def self.up
    add_column :landing_pages, :show_apartments_by_area, :boolean, :default => true
  end

  def self.down
    remove_column :landing_pages, :show_apartments_by_area
  end
end
