class AddShortDescriptionToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :short_description, :string
  end

  def self.down
    remove_column :properties, :short_description
  end
end
