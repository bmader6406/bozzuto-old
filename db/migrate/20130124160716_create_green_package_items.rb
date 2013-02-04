class CreateGreenPackageItems < ActiveRecord::Migration
  def self.up
    create_table :green_package_items do |t|
      t.integer :green_package_id, :null => false
      t.integer :green_feature_id, :null => false

      t.decimal :savings, :null => false, :precision => 8, :scale => 2, :default => 0

      t.boolean :ultra_green, :default => false, :null => false

      t.integer :x, :default => 0
      t.integer :y, :default => 0

      t.integer :position

      t.timestamps
    end

    add_index :green_package_items, :green_package_id
  end

  def self.down
    drop_table :green_package_items
  end
end
