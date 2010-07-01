class CreatePropertyMiniSlideshows < ActiveRecord::Migration
  def self.up
    create_table :property_mini_slideshows do |t|
      t.string  :name, :null => false
      t.integer :property_id

      t.timestamps
    end
  end

  def self.down
    drop_table :property_mini_slideshows
  end
end
