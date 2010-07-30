class CreatePressReleases < ActiveRecord::Migration
  def self.up
    create_table :press_releases do |t|
      t.string   :title, :null => false
      t.text     :body
      t.boolean  :published, :default => false, :null => false
      t.datetime :published_at
      t.string   :meta_title
      t.string   :meta_description
      t.string   :meta_keywords

      t.timestamps
    end
  end

  def self.down
    drop_table :press_releases
  end
end
