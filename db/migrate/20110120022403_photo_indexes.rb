class PhotoIndexes < ActiveRecord::Migration
  def self.up
    add_index :photo_sets, :property_id
    add_index :photo_groups_photos, :photo_id
    add_index :photo_groups_photos, :photo_group_id
    add_index :photos, :photo_set_id
  end

  def self.down
    remove_index :photos, :photo_set_id
    remove_index :photo_groups_photos, :photo_group_id
    remove_index :photo_groups_photos, :photo_id
    remove_index :photo_sets, :property_id
  end
end