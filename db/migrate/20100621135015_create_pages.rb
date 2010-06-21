class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :title, :null => false
      t.string :cached_slug
      t.text   :body

      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :section_id

      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
