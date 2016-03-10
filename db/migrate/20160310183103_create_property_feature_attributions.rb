class CreatePropertyFeatureAttributions < ActiveRecord::Migration
  def change
    create_table :property_feature_attributions do |t|
      t.integer :property_id,         null: false
      t.string  :property_type,       null: false
      t.integer :property_feature_id, null: false

      t.timestamps null: false
    end

    add_index :property_feature_attributions, :property_feature_id
    add_index :property_feature_attributions, [:property_id, :property_type], name: 'index_property_id_and_type_on_feature_attribution'
    add_index :property_feature_attributions, [:property_id, :property_type, :property_feature_id], unique: true, name: 'index_properties_and_features'
  end
end
