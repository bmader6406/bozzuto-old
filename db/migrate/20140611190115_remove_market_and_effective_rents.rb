class RemoveMarketAndEffectiveRents < ActiveRecord::Migration
  def self.up
    remove_column :properties, :use_market_prices

    remove_column :apartment_floor_plans, :min_market_rent
    remove_column :apartment_floor_plans, :max_market_rent
    remove_column :apartment_floor_plans, :min_effective_rent
    remove_column :apartment_floor_plans, :max_effective_rent
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
