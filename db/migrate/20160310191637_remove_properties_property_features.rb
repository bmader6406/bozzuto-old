class RemovePropertiesPropertyFeatures < ActiveRecord::Migration
  def up
    drop_table :properties_property_features
  end

  def down
    create_table :properties_property_features, id: false do |t|
      t.integer :property_id
      t.integer :property_feature_id
    end
  end
end
