class AddImageFieldsToFloorPlan < ActiveRecord::Migration
  def self.up
    rename_column :floor_plans, :image, :image_url

    add_column :floor_plans, :image_type, :integer, :default => 0, :null => false
    add_column :floor_plans, :image_file_name, :string
    add_column :floor_plans, :image_content_type, :string
  end

  def self.down
    rename_column :floor_plans, :image_url, :image

    remove_column :floor_plans, :image_type
    remove_column :floor_plans, :image_file_name
    remove_column :floor_plans, :image_content_type
  end
end
