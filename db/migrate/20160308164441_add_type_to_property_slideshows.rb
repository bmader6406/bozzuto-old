class AddTypeToPropertySlideshows < ActiveRecord::Migration
  def change
    add_column :property_slideshows, :property_type, :string
  end
end
