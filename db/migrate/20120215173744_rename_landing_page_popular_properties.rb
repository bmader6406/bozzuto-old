class RenameLandingPagePopularProperties < ActiveRecord::Migration
  def self.up
    rename_table :landing_page_popular_properties, :landing_page_popular_orderings
  end

  def self.down
    rename_table :landing_page_popular_orderings, :landing_page_popular_properties
  end
end
