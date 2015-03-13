class CreateApartmentUnitAmenities < ActiveRecord::Migration
  def self.up
    create_table :apartment_unit_amenities do |t|
      t.integer :apartment_unit_id, :null => false
      t.string  :primary_type,      :null => false, :default => 'Other'
      t.string  :sub_type
      t.string  :description
      t.integer :rank
      
      t.timestamps
    end

    add_index :apartment_unit_amenities, :apartment_unit_id
  end

  def self.down
    drop_table :apartment_unit_amenities
  end
end
