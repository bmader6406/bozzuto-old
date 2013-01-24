class CreateGreenPackages < ActiveRecord::Migration
  def self.up
    create_table :green_packages do |t|
      t.integer :home_community_id, :null => false

      t.string :photo_file_name, :null => false
      t.string :photo_content_type, :null => false

      t.timestamps
    end

    add_index :green_packages, :home_community_id, :unique => true
  end

  def self.down
    drop_table :green_packages
  end
end
