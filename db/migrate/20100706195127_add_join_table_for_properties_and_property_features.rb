class AddJoinTableForPropertiesAndPropertyFeatures < ActiveRecord::Migration
  def self.up
    create_table :properties_property_features, :id => false do |t|
      t.integer :property_id
      t.integer :property_feature_id
    end
  end

  def self.down
    drop_table :properties_property_features
  end
end
