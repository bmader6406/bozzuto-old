class CreatePropertyToursPages < ActiveRecord::Migration
  def self.up
    create_table :property_tours_pages do |t|
      t.integer :property_id, :null => false
      t.string :title
      t.text :content
      t.string :meta_title
      t.string :meta_description
      t.string :meta_keywords

      t.timestamps
    end

    add_index :property_tours_pages, :property_id
  end

  def self.down
    drop_table :property_tours_pages
  end
end
