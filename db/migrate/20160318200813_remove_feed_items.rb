class RemoveFeedItems < ActiveRecord::Migration
  def change
    drop_table :feed_items do |t|
      t.integer  :feed_id,      null: false
      t.string   :title,        null: false
      t.string   :url,          null: false
      t.text     :description,  null: false
      t.datetime :published_at, null: false
    end
  end
end
