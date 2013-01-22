class CreateGreenFeatures < ActiveRecord::Migration
  def self.up
    create_table :green_features do |t|
      t.string :title, :null => false
      t.text   :description

      t.string :photo_file_name, :null => false
      t.string :photo_content_type, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :green_features
  end
end
