class AddFeaturedFlagToCarouselPanel < ActiveRecord::Migration
  def self.up
    add_column :carousel_panels, :featured, :boolean, :default => false
  end

  def self.down
    remove_column :carousel_panels, :featured
  end
end
