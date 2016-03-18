class RemoveFeeds < ActiveRecord::Migration
  def change
    drop_table :feeds do |t|
      t.string   :name,         null: false
      t.string   :url,          null: false
      t.datetime :refreshed_at
    end
  end
end
