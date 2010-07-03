class CreateBodySlides < ActiveRecord::Migration
  def self.up
    create_table :body_slides do |t|
      t.with_options :null => false do |n|
        t.string  :image_file_name
        t.string  :image_content_type
        t.integer :slideshow_id
      end
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :body_slides
  end
end
