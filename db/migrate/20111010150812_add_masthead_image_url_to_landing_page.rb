class AddMastheadImageUrlToLandingPage < ActiveRecord::Migration
  def self.up
    add_column :landing_pages, :masthead_image_url, :string
  end

  def self.down
    remove_column :landing_pages, :masthead_image_url
  end
end
