class AddFeaturedProjectFieldToBodySlide < ActiveRecord::Migration
  def self.up
    add_column :body_slides, :property_id, :integer
  end

  def self.down
    remove_column :body_slides, :property_id
  end
end
