class RemoveFloorPlanCacheFieldsFromProperties < ActiveRecord::Migration
  def self.up
    remove_column :properties, :cheapest_studio_price
    remove_column :properties, :cheapest_1_bedroom_price
    remove_column :properties, :cheapest_2_bedroom_price
    remove_column :properties, :cheapest_3_bedroom_price
    remove_column :properties, :cheapest_penthouse_price

    remove_column :properties, :plan_count_studio
    remove_column :properties, :plan_count_1_bedroom
    remove_column :properties, :plan_count_2_bedroom
    remove_column :properties, :plan_count_3_bedroom
    remove_column :properties, :plan_count_penthouse
  end

  def self.down
    add_column :properties, :cheapest_studio_price,    :string
    add_column :properties, :cheapest_1_bedroom_price, :string
    add_column :properties, :cheapest_2_bedroom_price, :string
    add_column :properties, :cheapest_3_bedroom_price, :string
    add_column :properties, :cheapest_penthouse_price, :string

    add_column :properties, :plan_count_studio,    :integer, :default => 0
    add_column :properties, :plan_count_1_bedroom, :integer, :default => 0
    add_column :properties, :plan_count_2_bedroom, :integer, :default => 0
    add_column :properties, :plan_count_3_bedroom, :integer, :default => 0
    add_column :properties, :plan_count_penthouse, :integer, :default => 0
  end
end
