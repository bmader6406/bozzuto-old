class CreateNewsPosts < ActiveRecord::Migration
  def self.up
    create_table :news_posts do |t|
      t.string   :title, :null => false
      t.text     :body
      t.boolean  :published, :default => false, :null => false
      t.datetime :published
      t.integer  :section_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :news_posts
  end
end
