class CreateSeoMetadatas < ActiveRecord::Migration
  def self.up
    create_table :seo_metadata do |t|
      t.integer :resource_id,   :null => false
      t.string  :resource_type, :null => false
      t.string  :meta_title
      t.string  :meta_description
      t.string  :meta_keywords

      t.timestamps
    end
  end

  def self.down
    drop_table :seo_metadata
  end
end
