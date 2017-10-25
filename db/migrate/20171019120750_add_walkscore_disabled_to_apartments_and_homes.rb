class AddWalkscoreDisabledToApartmentsAndHomes < ActiveRecord::Migration
  def self.up
    add_column :apartment_communities, :walkscore_disabled, :boolean, :default => false, :null => false
    add_column :home_communities, :walkscore_disabled, :boolean, :default => false, :null => false

    add_index :apartment_communities, :walkscore_disabled
    add_index :home_communities, :walkscore_disabled
  end

  def self.down
    remove_column :apartment_communities, :walkscore_disabled
    remove_column :home_communities, :walkscore_disabled
  end
end
