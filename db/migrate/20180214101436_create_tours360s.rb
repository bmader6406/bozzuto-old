class CreateTours360s < ActiveRecord::Migration
  def self.up
    create_table :tours360s do |t|
    	t.string :image_file_name
      t.string :image_content_type
      t.string :url, :null => false
      t.integer :property_id
      t.string :property_type
      t.integer :position

      t.timestamps null: false
    end
  end

  def self.down
    drop_table :tours360s
  end
end