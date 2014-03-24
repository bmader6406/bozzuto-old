class RemoveDescriptionFromMetros < ActiveRecord::Migration
  def self.up
    remove_column :metros, :description
  end

  def self.down
    add_column :metros, :description, :text
  end
end
