class CreatePropertyAmenities < ActiveRecord::Migration
  def self.up
    create_table :property_amenities do |t|
      t.integer :property_id,  :null => false
      t.string  :primary_type, :null => false, :default => 'Other'
      t.string  :sub_type
      t.string  :description
      t.integer :position

      t.timestamps
    end

    add_index :property_amenities, :property_id
  end

  def self.down
    drop_table :property_amenities
  end
end
