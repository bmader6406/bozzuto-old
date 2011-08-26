class CreateRanks < ActiveRecord::Migration
  def self.up
    create_table :ranks do |t|
      t.integer :rank_number, :null => false
      t.integer :year, :null => false
      t.string  :description
      t.integer :rank_category_id

      t.timestamps
    end

    add_index :ranks, [:rank_category_id, :year]
  end

  def self.down
    drop_table :ranks
  end
end
