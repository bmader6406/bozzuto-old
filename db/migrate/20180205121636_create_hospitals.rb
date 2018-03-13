class CreateHospitals < ActiveRecord::Migration
  def self.up
    create_table :hospitals do |t|
      t.string :name
      t.string :slug
      t.float :latitude
      t.float :longitude
      t.integer :position
      t.string :listing_image_file_name
      t.references :hospital_region, index: true, foreign_key: true
      t.text :description
      t.text :detail_description

      t.timestamps null: false
    end

    add_index :hospitals, :name, :unique => true
    add_index :hospitals, :slug
    add_index :hospitals, :latitude
    add_index :hospitals, :longitude
  end

  def self.down
    drop_table :hospitals
  end
end
