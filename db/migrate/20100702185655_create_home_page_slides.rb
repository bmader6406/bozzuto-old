class CreateHomePageSlides < ActiveRecord::Migration
  def self.up
    create_table :home_page_slides do |t|
      t.with_options :null => false do |n|
        n.integer :home_page_id
        n.string  :image_file_name
        n.string  :image_content_type
      end

      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :home_page_slides
  end
end
