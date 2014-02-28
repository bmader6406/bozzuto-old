class CreateMetros < ActiveRecord::Migration
  def self.up
    create_table :metros do |t|
      t.string  :name,                    :null => false
      t.string  :cached_slug
      t.float   :latitude,                :null => false
      t.float   :longitude,               :null => false
      t.integer :position
      t.string  :banner_image_file_name
      t.string  :listing_image_file_name, :null => false

      t.timestamps
    end

    add_index :metros, :cached_slug
    add_index :metros, :name, :unique => true
  end

  def self.down
    drop_table :metros
  end
end
