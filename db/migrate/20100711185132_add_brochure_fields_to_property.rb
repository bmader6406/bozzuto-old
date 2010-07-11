class AddBrochureFieldsToProperty < ActiveRecord::Migration
  def self.up
    add_column :properties, :brochure_type, :integer, :default => 0, :null => false
    add_column :properties, :brochure_link_text, :string
    add_column :properties, :brochure_file_name, :string
    add_column :properties, :brochure_content_type, :string
    add_column :properties, :brochure_url, :string
  end

  def self.down
    remove_column :properties, :brochure_type
    remove_column :properties, :brochure_link_text
    remove_column :properties, :brochure_file_name
    remove_column :properties, :brochure_content_type
    remove_column :properties, :brochure_url
  end
end
