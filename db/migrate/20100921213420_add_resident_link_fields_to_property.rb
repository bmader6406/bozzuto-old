class AddResidentLinkFieldsToProperty < ActiveRecord::Migration
  def self.up
    add_column :properties, :resident_link_text, :string
    add_column :properties, :resident_link_url, :string
  end

  def self.down
    remove_column :properties, :resident_link_text
    remove_column :properties, :resident_link_url
  end
end
