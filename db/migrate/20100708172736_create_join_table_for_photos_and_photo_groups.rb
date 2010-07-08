class CreateJoinTableForPhotosAndPhotoGroups < ActiveRecord::Migration
  def self.up
    create_table :photo_groups_photos, :id => false do |t|
      t.integer :photo_group_id
      t.integer :photo_id
    end
  end

  def self.down
    drop_table :photo_groups_photos
  end
end
