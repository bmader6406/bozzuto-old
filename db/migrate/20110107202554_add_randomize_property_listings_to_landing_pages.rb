class AddRandomizePropertyListingsToLandingPages < ActiveRecord::Migration
  def self.up
    add_column :landing_pages, :randomize_property_listings, :boolean
  end

  def self.down
    remove_column :landing_pages, :randomize_property_listings
  end
end
