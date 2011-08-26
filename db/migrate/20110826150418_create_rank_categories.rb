class CreateRankCategories < ActiveRecord::Migration
  def self.up
    create_table :rank_categories do |t|
      t.string  :name, :null => false
      t.integer :position
      t.integer :publication_id, :null => false

      t.timestamps
    end

    add_index :rank_categories, [:publication_id, :position]
  end

  def self.down
    drop_table :rank_categories
  end
end
