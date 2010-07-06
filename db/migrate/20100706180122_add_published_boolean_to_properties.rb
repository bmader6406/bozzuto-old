class AddPublishedBooleanToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :published, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :properties, :published
  end
end
