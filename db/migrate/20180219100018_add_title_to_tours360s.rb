class AddTitleToTours360s < ActiveRecord::Migration
  def self.up
    add_column :tours360s, :title, :string

    add_index :tours360s, :title
  end

  def self.down
    remove_column :tours360s, :title
  end
end
