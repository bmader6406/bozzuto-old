class CreateSnippets < ActiveRecord::Migration
  def self.up
    create_table :snippets do |t|
      t.string :name, :null => false, :unique => true
      t.text :body, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :snippets
  end
end
