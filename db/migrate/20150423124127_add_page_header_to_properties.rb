class AddPageHeaderToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :page_header, :string
  end

  def self.down
    remove_column :properties, :page_header
  end
end
