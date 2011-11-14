class AddVideoUrlToPropertySlide < ActiveRecord::Migration
  def self.up
    add_column :property_slides, :video_url, :string
  end

  def self.down
    remove_column :property_slides, :video_url
  end
end
