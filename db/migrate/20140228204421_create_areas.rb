class CreateAreas < ActiveRecord::Migration
  def self.up
    create_table :areas do |t|
      t.string  :name,                    :null => false
      t.string  :cached_slug
      t.float   :latitude,                :null => false
      t.float   :longitude,               :null => false
      t.integer :metro_id,                :null => false
      t.integer :position
      t.string  :banner_image_file_name
      t.string  :listing_image_file_name, :null => false

      t.timestamps
    end

    add_index :areas, :name, :unique => true
    add_index :areas, :cached_slug
    add_index :areas, :metro_id
  end

  def self.down
    drop_table :areas
  end
end
