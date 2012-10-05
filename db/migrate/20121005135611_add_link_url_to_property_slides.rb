class AddLinkUrlToPropertySlides < ActiveRecord::Migration
  def self.up
    add_column :property_slides, :link_url, :string
  end

  def self.down
    remove_column :property_slides, :link_url
  end
end
