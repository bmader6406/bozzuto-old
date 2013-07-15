class ChangeExternalCmsIdAttributesFromIntegerToString < ActiveRecord::Migration
  def self.up
    change_column :properties, :external_cms_id, :string
    change_column :apartment_floor_plans, :external_cms_id, :string
    change_column :apartment_floor_plans, :external_cms_file_id, :string
  end

  def self.down
    change_column :properties, :external_cms_id, :integer
    change_column :apartment_floor_plans, :external_cms_id, :integer
    change_column :apartment_floor_plans, :external_cms_file_id, :integer
  end
end
