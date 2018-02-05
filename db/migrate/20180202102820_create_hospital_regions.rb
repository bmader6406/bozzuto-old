class CreateHospitalRegions < ActiveRecord::Migration
  def change
    create_table :hospital_regions do |t|
      t.string :name
      t.string :slug
      t.float :latitude
      t.float :longitude
      t.text :detail_description

      t.timestamps null: false
    end
  end
end
