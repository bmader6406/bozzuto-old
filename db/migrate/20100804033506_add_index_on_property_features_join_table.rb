class AddIndexOnPropertyFeaturesJoinTable < ActiveRecord::Migration
  def self.up
    add_index :properties_property_features, :property_id
  end

  def self.down
    remove_index :properties_property_features, :property_id
  end
end
