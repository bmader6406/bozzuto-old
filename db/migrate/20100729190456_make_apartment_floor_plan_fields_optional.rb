class MakeApartmentFloorPlanFieldsOptional < ActiveRecord::Migration
  def self.up
    set_null_to(true)
  end

  def self.down
    set_null_to(false)
  end

  def self.set_null_to(is_null)
    change_column :apartment_floor_plans,
      :availability_url, :string,
      :null => is_null
    change_column :apartment_floor_plans,
      :bedrooms, :integer,
      :null => is_null
    change_column :apartment_floor_plans,
      :bathrooms, :decimal,
      :precision => 3,
      :scale => 1,
      :null => is_null
    change_column :apartment_floor_plans,
      :min_square_feet, :integer,
      :null => is_null
    change_column :apartment_floor_plans,
      :max_square_feet, :integer,
      :null => is_null
    change_column :apartment_floor_plans,
      :min_market_rent, :decimal,
      :precision => 6,
      :scale => 2,
      :null => is_null
    change_column :apartment_floor_plans,
      :max_market_rent, :decimal,
      :precision => 6,
      :scale => 2,
      :null => is_null
    change_column :apartment_floor_plans,
      :min_effective_rent, :decimal,
      :precision => 6,
      :scale => 2,
      :null => is_null
    change_column :apartment_floor_plans,
      :max_effective_rent, :decimal,
      :precision => 6,
      :scale => 2,
      :null => is_null
    change_column :apartment_floor_plans,
      :min_rent, :decimal,
      :precision => 6,
      :scale => 2,
      :null => is_null
    change_column :apartment_floor_plans,
      :max_rent, :decimal,
      :precision => 6,
      :scale => 2,
      :null => is_null
  end
end
