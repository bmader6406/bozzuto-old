class RemoveAssets < ActiveRecord::Migration
  def up
    drop_table :assets
  end

  def down
    create_table :assets do |t|
      t.string   :data_file_name
      t.string   :data_content_type
      t.integer  :data_file_size
      t.string   :type
      t.integer  :typus_user_id

      t.timestamps
    end
  end
end
