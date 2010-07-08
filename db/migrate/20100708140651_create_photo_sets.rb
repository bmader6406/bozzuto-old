class CreatePhotoSets < ActiveRecord::Migration
  def self.up
    create_table :photo_sets do |t|
      t.string  :title, :null => false
      t.string  :flickr_set_id, :null => false
      t.integer :community_id

      t.timestamps
    end
  end

  def self.down
    drop_table :photo_sets
  end
end
