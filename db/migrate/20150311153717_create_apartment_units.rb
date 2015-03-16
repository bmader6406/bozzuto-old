class CreateApartmentUnits < ActiveRecord::Migration
  def self.up
    create_table :apartment_units do |t|
      t.string  :external_cms_id
      t.string  :external_cms_type
      t.string  :building_external_cms_id
      t.string  :floorplan_external_cms_id
      t.string  :organization_name
      t.string  :marketing_name
      t.string  :unit_type
      t.decimal :bedrooms,    :precision => 3, :scale => 1
      t.decimal :bathrooms,   :precision => 3, :scale => 1
      t.integer :min_square_feet
      t.integer :max_square_feet
      t.string  :square_foot_type
      t.decimal :unit_rent,   :precision => 8, :scale => 2
      t.decimal :market_rent, :precision => 8, :scale => 2
      t.string  :economic_status
      t.string  :economic_status_description
      t.string  :occupancy_status
      t.string  :occupancy_status_description
      t.string  :leased_status
      t.string  :leased_status_description
      t.integer :number_occupants
      t.string  :floor_plan_name
      t.string  :phase_name
      t.string  :building_name
      t.string  :primary_property_id
      t.string  :address_line_1
      t.string  :address_line_2
      t.string  :city
      t.string  :state
      t.string  :zip
      t.string  :comment
      t.decimal :min_rent,    :precision => 8, :scale => 2
      t.decimal :max_rent,    :precision => 8, :scale => 2
      t.decimal :avg_rent,    :precision => 8, :scale => 2
      t.date    :vacate_date
      t.string  :vacancy_class
      t.date    :made_ready_date
      t.text    :availability_url
      t.integer :floor_plan_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :apartment_units
  end
end
