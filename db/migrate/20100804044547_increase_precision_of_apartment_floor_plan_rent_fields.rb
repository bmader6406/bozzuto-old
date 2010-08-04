class IncreasePrecisionOfApartmentFloorPlanRentFields < ActiveRecord::Migration
  def self.up
    change_column :apartment_floor_plans, :min_market_rent, :decimal,
      :precision => 8,
      :scale => 2
    change_column :apartment_floor_plans, :max_market_rent, :decimal,
      :precision => 8,
      :scale => 2
    change_column :apartment_floor_plans, :min_effective_rent, :decimal,
      :precision => 8,
      :scale => 2
    change_column :apartment_floor_plans, :max_effective_rent, :decimal,
      :precision => 8,
      :scale => 2
    change_column :apartment_floor_plans, :min_rent, :decimal,
      :precision => 8,
      :scale => 2
    change_column :apartment_floor_plans, :max_rent, :decimal,
      :precision => 8,
      :scale => 2
  end

  def self.down
    change_column :apartment_floor_plans, :min_market_rent, :decimal,
      :precision => 6,
      :scale => 2
    change_column :apartment_floor_plans, :max_market_rent, :decimal,
      :precision => 6,
      :scale => 2
    change_column :apartment_floor_plans, :min_effective_rent, :decimal,
      :precision => 6,
      :scale => 2
    change_column :apartment_floor_plans, :max_effective_rent, :decimal,
      :precision => 6,
      :scale => 2
    change_column :apartment_floor_plans, :min_rent, :decimal,
      :precision => 6,
      :scale => 2
    change_column :apartment_floor_plans, :max_rent, :decimal,
      :precision => 6,
      :scale => 2
  end
end
