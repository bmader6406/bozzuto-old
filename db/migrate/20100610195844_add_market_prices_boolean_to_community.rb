class AddMarketPricesBooleanToCommunity < ActiveRecord::Migration
  def self.up
    add_column :communities, :use_market_prices, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :communities, :use_market_prices
  end
end
