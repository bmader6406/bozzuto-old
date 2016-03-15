class CreatePropertyFeedImports < ActiveRecord::Migration
  def change
    create_table :property_feed_imports do |t|
      t.string   :type,               null: false
      t.string   :state,              null: false
      t.string   :file_file_name
      t.string   :file_file_size
      t.string   :file_content_type
      t.text     :error
      t.datetime :started_at
      t.datetime :finished_at

      t.timestamps null: false
    end
  end
end
