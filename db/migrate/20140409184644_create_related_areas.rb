class CreateRelatedAreas < ActiveRecord::Migration
  def self.up
    create_table :related_areas do |t|
      t.integer :area_id,        :null => false
      t.integer :nearby_area_id, :null => false
      t.integer :position

      t.timestamps
    end

    add_index :related_areas, :area_id
    add_index :related_areas, [:area_id, :nearby_area_id], :unique => true
  end

  def self.down
    drop_table :related_areas
  end
end
