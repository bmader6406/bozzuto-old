class CreateHospitals < ActiveRecord::Migration
  def change
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
  end
end
