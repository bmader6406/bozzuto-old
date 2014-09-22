class UpdateApartmentFloorPlanFieldsForExternalCms < ActiveRecord::Migration
  def self.up
    rename_column :apartment_floor_plans, :vaultware_floor_plan_id, :external_cms_id
    rename_column :apartment_floor_plans, :vaultware_file_id, :external_cms_file_id

    add_column :apartment_floor_plans, :external_cms_type, :string

    add_index :apartment_floor_plans, :external_cms_id
    add_index :apartment_floor_plans, [:external_cms_id, :external_cms_type], :name => 'index_external_cms_id_and_type'

    execute "UPDATE apartment_floor_plans SET external_cms_type = 'vaultware' WHERE external_cms_id IS NOT NULL"
  end

  def self.down
    remove_index :apartment_floor_plans, :external_cms_id
    remove_index :apartment_floor_plans, [:external_cms_id, :external_cms_type]

    remove_column :apartment_floor_plans, :external_cms_type

    rename_column :apartment_floor_plans, :external_cms_id, :vaultware_floor_plan_id
    rename_column :apartment_floor_plans, :external_cms_file_id, :vaultware_file_id
  end
end
