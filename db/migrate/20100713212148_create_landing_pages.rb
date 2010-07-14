class CreateLandingPages < ActiveRecord::Migration
  def self.up
    create_table :landing_pages do |t|
      t.string :title, :null => false
      t.string :cached_slug
      t.text   :masthead_body
      t.string :masthead_image_file_name
      t.string :masthead_image_content_type

      t.string :secondary_title
      t.text   :secondary_body

      t.timestamps
    end
  end

  def self.down
    drop_table :landing_pages
  end
end
