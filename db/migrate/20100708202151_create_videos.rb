class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.string :image_file_name
      t.string :image_content_type
      t.string :url, :null => false
      t.integer :property_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :videos
  end
end
