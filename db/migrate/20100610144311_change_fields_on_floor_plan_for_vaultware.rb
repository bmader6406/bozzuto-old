class ChangeFieldsOnFloorPlanForVaultware < ActiveRecord::Migration
  def self.up
    change_column :floor_plans, :image, :string, :null => true
    remove_column :floor_plans, :square_feet
    remove_column :floor_plans, :price
    remove_column :floor_plans, :category

    add_column :floor_plans, :name, :string, :null => false
    add_column :floor_plans, :availability_url, :string, :null => false

    add_column :floor_plans, :min_square_feet, :integer, :null => false
    add_column :floor_plans, :max_square_feet, :integer, :null => false

    add_column :floor_plans, :min_market_rent, :decimal, :precision => 6, :scale => 2, :null => false
    add_column :floor_plans, :max_market_rent, :decimal, :precision => 6, :scale => 2, :null => false

    add_column :floor_plans, :min_effective_rent, :decimal, :precision => 6, :scale => 2, :null => false
    add_column :floor_plans, :max_effective_rent, :decimal, :precision => 6, :scale => 2, :null => false
  end


  def self.down
    remove_column :floor_plans, :name
    remove_column :floor_plans, :availability_url

    remove_column :floor_plans, :min_square_feet
    remove_column :floor_plans, :max_square_feet

    remove_column :floor_plans, :min_market_rent
    remove_column :floor_plans, :max_market_rent

    remove_column :floor_plans, :min_effective_rent
    remove_column :floor_plans, :max_effective_rent

    change_column :floor_plans, :image, :string, :null => false
    add_column :floor_plans, :square_feet, :integer, :null => false
    add_column :floor_plans, :price, :integer, :null => false
    add_column :floor_plans, :category, :string, :null => false
  end
end
