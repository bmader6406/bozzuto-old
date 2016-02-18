class CreatePropertyRetailPages < ActiveRecord::Migration
  def self.up
    create_table :property_retail_pages do |t|
      t.integer :property_id, :null => false
      t.text    :content
      t.string  :meta_title
      t.string  :meta_description
      t.string  :meta_keywords

      t.timestamps
    end
  end

  def self.down
    drop_table :property_retail_pages
  end
end
