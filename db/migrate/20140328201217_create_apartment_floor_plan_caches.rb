class CreateApartmentFloorPlanCaches < ActiveRecord::Migration
  def self.up
    create_table :apartment_floor_plan_caches do |t|
      t.integer :cacheable_id,   :null => false
      t.string  :cacheable_type, :null => false

      t.decimal :studio_min_price, :default => 0, :precision => 8, :scale => 2
      t.integer :studio_count,     :default => 0

      t.decimal :one_bedroom_min_price, :default => 0, :precision => 8, :scale => 2
      t.integer :one_bedroom_count,     :default => 0

      t.decimal :two_bedrooms_min_price, :default => 0, :precision => 8, :scale => 2
      t.integer :two_bedrooms_count,     :default => 0

      t.decimal :three_bedrooms_min_price, :default => 0, :precision => 8, :scale => 2
      t.integer :three_bedrooms_count,     :default => 0

      t.decimal :penthouse_min_price, :default => 0, :precision => 8, :scale => 2
      t.integer :penthouse_count,     :default => 0

      t.decimal :min_price, :default => 0, :precision => 8, :scale => 2
      t.decimal :max_price, :default => 0, :precision => 8, :scale => 2

      t.timestamps
    end

    add_index :apartment_floor_plan_caches, [:cacheable_id, :cacheable_type], :unique => true
  end

  def self.down
    drop_table :apartment_floor_plan_caches
  end
end
