class ReprocessPropertyListingImages < ActiveRecord::Migration
  def self.up
    Property.all.each { |p| p.listing_image.reprocess! }
  end

  def self.down
  end
end
