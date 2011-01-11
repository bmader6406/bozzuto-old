class CreatePropertyFeaturesPages < ActiveRecord::Migration
  def self.up
    create_table :property_features_pages do |t|
      t.integer  :property_id, :null => false
      t.text     :text_1
      t.string   :title_1
      t.string   :title_2
      t.text     :text_2
      t.string   :title_3
      t.text     :text_3
      t.string   :meta_title
      t.string   :meta_description
      t.string   :meta_keywords
      t.timestamps
    end
    add_index :property_features_pages, :property_id
  end

  def self.down
    drop_table :property_features_pages
  end
end