class CreateMediaplexTags < ActiveRecord::Migration
  def self.up
    create_table :mediaplex_tags do |t|
      t.string  :page_name
      t.string  :roi_name
      t.integer :trackable_id
      t.string  :trackable_type

      t.timestamps
    end

    add_index :mediaplex_tags, [:trackable_type, :trackable_id]
  end

  def self.down
    drop_table :mediaplex_tags
  end
end
