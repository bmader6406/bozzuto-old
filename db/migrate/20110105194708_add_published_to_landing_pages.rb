class AddPublishedToLandingPages < ActiveRecord::Migration
  def self.up
    add_column :landing_pages, :published, :boolean, :default => false, :null => false
    LandingPage.all.each do |page|
      page.update_attribute(:published, true)
    end
  end

  def self.down
    remove_column :landing_pages, :published
  end
end
