class CreatePropertyNeighborhoodPages < ActiveRecord::Migration
  def self.up
    create_table :property_neighborhood_pages do |t|
      t.integer :property_id, :null => false
      t.text :content
      t.string :meta_title
      t.string :meta_description
      t.string :meta_keywords
      t.timestamps
    end
    add_index :property_neighborhood_pages, :property_id
  end

  def self.down
    drop_table :property_neighborhood_pages
  end
end