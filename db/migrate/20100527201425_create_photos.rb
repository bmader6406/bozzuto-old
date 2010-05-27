class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.with_options :null => false do |n|
        n.string :image
        n.integer :community_id
        n.string :caption
      end

      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
