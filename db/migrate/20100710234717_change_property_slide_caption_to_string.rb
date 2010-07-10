class ChangePropertySlideCaptionToString < ActiveRecord::Migration
  def self.up
    change_column :property_slides, :caption, :string
  end

  def self.down
    change_column :property_slides, :caption, :text
  end
end
