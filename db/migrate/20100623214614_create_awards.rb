class CreateAwards < ActiveRecord::Migration
  def self.up
    create_table :awards do |t|
      t.string   :title, :null => false
      t.text     :body
      t.integer  :section_id
      t.boolean  :published, :default => false, :null => false
      t.datetime :published_at

      t.timestamps
    end
  end

  def self.down
    drop_table :awards
  end
end
