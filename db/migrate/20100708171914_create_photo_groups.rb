class CreatePhotoGroups < ActiveRecord::Migration
  def self.up
    create_table :photo_groups do |t|
      t.string :title, :null => false
      t.string :flickr_raw_title, :null => false
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :photo_groups
  end
end
