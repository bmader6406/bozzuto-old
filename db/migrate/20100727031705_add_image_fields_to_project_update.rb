class AddImageFieldsToProjectUpdate < ActiveRecord::Migration
  def self.up
    add_column :project_updates, :image_file_name, :string
    add_column :project_updates, :image_content_type, :string
    add_column :project_updates, :image_title, :string
    add_column :project_updates, :image_description, :string
  end

  def self.down
    remove_column :project_updates, :image_file_name
    remove_column :project_updates, :image_content_type
    remove_column :project_updates, :image_title
    remove_column :project_updates, :image_description
  end
end
