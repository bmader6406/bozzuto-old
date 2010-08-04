class AddCheapestGroupPriceCacheFieldToProperty < ActiveRecord::Migration
  def self.up
    add_column :properties, :cheapest_studio_price, :string
    add_column :properties, :cheapest_1_bedroom_price, :string
    add_column :properties, :cheapest_2_bedroom_price, :string
    add_column :properties, :cheapest_3_bedroom_price, :string
    add_column :properties, :cheapest_penthouse_price, :string
  end

  def self.down
    remove_column :properties, :cheapest_studio_price
    remove_column :properties, :cheapest_1_bedroom_price
    remove_column :properties, :cheapest_2_bedroom_price
    remove_column :properties, :cheapest_3_bedroom_price
    remove_column :properties, :cheapest_penthouse_price
  end
end
