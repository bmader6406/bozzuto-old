class CreateNeighborhoods < ActiveRecord::Migration
  def self.up
    create_table :neighborhoods do |t|
      t.string  :name,                    :null => false
      t.string  :cached_slug
      t.float   :latitude,                :null => false
      t.float   :longitude,               :null => false
      t.string  :banner_image_file_name,  :null => false
      t.string  :listing_image_file_name, :null => false
      t.integer :area_id,                 :null => false
      t.integer :position
      t.integer :state_id,                :null => false

      t.timestamps
    end

    add_index :neighborhoods, :name, :unique => true
    add_index :neighborhoods, :cached_slug
    add_index :neighborhoods, :area_id
  end

  def self.down
    drop_table :neighborhoods
  end
end
