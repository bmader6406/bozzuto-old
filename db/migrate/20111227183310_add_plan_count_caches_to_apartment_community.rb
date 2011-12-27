class AddPlanCountCachesToApartmentCommunity < ActiveRecord::Migration
  def self.up
    add_column :properties, :plan_count_studio, :integer, :default => 0
    add_column :properties, :plan_count_1_bedroom, :integer, :default => 0
    add_column :properties, :plan_count_2_bedroom, :integer, :default => 0
    add_column :properties, :plan_count_3_bedroom, :integer, :default => 0
    add_column :properties, :plan_count_penthouse, :integer, :default => 0
  end

  def self.down
    remove_column :properties, :plan_count_studio
    remove_column :properties, :plan_count_1_bedroom
    remove_column :properties, :plan_count_2_bedroom
    remove_column :properties, :plan_count_3_bedroom
    remove_column :properties, :plan_count_penthouse
  end
end
