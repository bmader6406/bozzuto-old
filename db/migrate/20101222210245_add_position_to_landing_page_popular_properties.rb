class AddPositionToLandingPagePopularProperties < ActiveRecord::Migration
  def self.up
    add_column :landing_page_popular_properties, :position, :integer
  end

  def self.down
    remove_column :landing_page_popular_properties, :position
  end
end