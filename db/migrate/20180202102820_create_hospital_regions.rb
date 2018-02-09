class CreateHospitalRegions < ActiveRecord::Migration
  def self.up
    create_table :hospital_regions do |t|
      t.string :name
      t.string :slug
      t.float :latitude
      t.float :longitude
      t.text :detail_description

      t.timestamps null: false
    end

    add_index :hospital_regions, :slug
    add_index :hospital_regions, :name, :unique => true
    add_index :hospital_regions, :latitude
    add_index :hospital_regions, :longitude
  end

  def self.down
    drop_table :hospital_regions
  end
end
