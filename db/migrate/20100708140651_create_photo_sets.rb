class CreatePhotoSets < ActiveRecord::Migration
  def self.up
    create_table :photo_sets do |t|
      t.string  :title, :null => false
      t.string  :flickr_set_number, :null => false
      t.integer :property_id

      t.timestamps
    end
  end

  def self.down
    drop_table :photo_sets
  end
end
