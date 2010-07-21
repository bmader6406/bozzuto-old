class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.string :data_file_name
      t.string :data_content_type
      t.integer :data_file_size

      t.string :type, :limit=>25

      t.integer :typus_user_id

      t.timestamps
    end

    add_index "assets", ["typus_user_id"]
  end

  def self.down
    drop_table :assets
  end
end
