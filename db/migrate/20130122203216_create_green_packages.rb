class CreateGreenPackages < ActiveRecord::Migration
  def self.up
    create_table :green_packages do |t|
      t.integer :home_community_id, :null => false

      t.string  :photo_file_name, :null => false
      t.string  :photo_content_type, :null => false

      t.decimal :ten_year_old_cost, :null => false, :precision => 8, :scale => 2, :default => 0

      t.string  :graph_title
      t.text    :graph_tooltip

      t.string  :graph_file_name
      t.string  :graph_content_type

      t.text    :disclaimer, :null => false

      t.timestamps
    end

    add_index :green_packages, :home_community_id, :unique => true
  end

  def self.down
    drop_table :green_packages
  end
end
