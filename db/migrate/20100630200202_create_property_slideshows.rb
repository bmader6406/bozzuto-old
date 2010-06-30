class CreatePropertySlideshows < ActiveRecord::Migration
  def self.up
    create_table :property_slideshows do |t|
      t.string  :name, :null => false
      t.integer :property_id

      t.timestamps
    end
  end

  def self.down
    drop_table :property_slideshows
  end
end
