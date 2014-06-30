class RemoveExternalCmsFileIdFromFloorPlans < ActiveRecord::Migration
  def self.up
    remove_column :apartment_floor_plans, :external_cms_file_id
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
