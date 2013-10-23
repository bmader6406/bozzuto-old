class AddWebsiteUrlTextToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :website_url_text, :string
  end

  def self.down
    remove_column :properties, :website_url_text
  end
end
