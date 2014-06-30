class RemoveRolledUpFromFloorPlans < ActiveRecord::Migration
  def self.up
    remove_column :apartment_floor_plans, :rolled_up
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
