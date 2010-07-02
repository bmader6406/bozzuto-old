class CreateHomePages < ActiveRecord::Migration
  def self.up
    create_table :home_pages do |t|
      t.string  :banner_image_file_name
      t.string  :banner_image_content_type
      t.text    :body
      t.integer :featured_property_id

      t.timestamps
    end
  end

  def self.down
    drop_table :home_pages
  end
end
