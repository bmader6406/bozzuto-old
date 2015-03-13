class CreateFeedFiles < ActiveRecord::Migration
  def self.up
    create_table :feed_files do |t|
      t.integer :feed_record_id,    :null => false
      t.string  :feed_record_type,  :null => false
      t.string  :external_cms_id,   :null => false
      t.string  :external_cms_type, :null => false
      t.boolean :active,            :null => false, :default => true
      t.string  :file_type,         :null => false, :default => 'Other'
      t.string  :description
      t.string  :name,              :null => false
      t.text    :caption
      t.string  :format,            :null => false
      t.text    :source,            :null => false
      t.integer :width
      t.integer :height
      t.string  :rank
      t.string  :ad_id
      t.string  :affiliate_id

      t.timestamps
    end

    add_index :feed_files, [:feed_record_id, :feed_record_type]
  end

  def self.down
    drop_table :feed_files
  end
end
