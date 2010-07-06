class CreatePropertyFeatures < ActiveRecord::Migration
  def self.up
    create_table :property_features do |t|
      t.string  :icon_file_name
      t.string  :icon_content_type
      t.string  :name
      t.text    :description
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :property_features
  end
end
