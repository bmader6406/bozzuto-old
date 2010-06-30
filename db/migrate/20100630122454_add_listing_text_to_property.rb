class AddListingTextToProperty < ActiveRecord::Migration
  def self.up
    add_column :properties, :listing_title, :string
    add_column :properties, :listing_text, :text
  end

  def self.down
    remove_column :properties, :listing_title
    remove_column :properties, :listing_text
  end
end
