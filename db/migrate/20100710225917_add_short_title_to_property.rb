class AddShortTitleToProperty < ActiveRecord::Migration
  def self.up
    add_column :properties, :short_title, :string
  end

  def self.down
    remove_column :properties, :short_title
  end
end
