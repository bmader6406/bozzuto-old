class AddUnderConstructionFlagToApartmentCommunities < ActiveRecord::Migration
  def self.up
    add_column :properties, :under_construction, :boolean, :default => false
  end

  def self.down
    remove_column :properties, :under_construction
  end
end
