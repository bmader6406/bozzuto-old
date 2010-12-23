class RenameLandingPagesPopularProperties < ActiveRecord::Migration
  def self.up
    rename_table :landing_pages_popular_properties, :landing_page_popular_properties
    execute <<-SQL
      ALTER TABLE landing_page_popular_properties
      ADD COLUMN id int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY
    SQL
  end

  def self.down
    remove_column :landing_page_popular_properties, :id
    rename_table :landing_page_popular_properties, :landing_pages_popular_properties
  end
end