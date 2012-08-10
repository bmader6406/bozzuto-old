class AddDataFeedFieldsToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :office_hours, :text
    add_column :properties, :pinterest_url, :string
  end

  def self.down
    remove_column :properties, :pinterest_url
    remove_column :properties, :office_hours
  end
end
