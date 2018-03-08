class CreateHospitalBlogs < ActiveRecord::Migration
  def self.up
    create_table :hospital_blogs do |t|
      t.string :title
      t.string :url
      t.string :listing_image_file_name
      t.references :hospital_region, index: true, unique: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :hospital_blogs, :title
    add_index :hospital_blogs, :url
  end

  def self.down
    drop_table :hospital_blogs
  end
end
