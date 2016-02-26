class RemoveCaptionFromPropertyRetailSlides < ActiveRecord::Migration
  def self.up
    remove_column :property_retail_slides, :caption
  end

  def self.down
    add_column :property_retail_slides, :caption, :string
  end
end
