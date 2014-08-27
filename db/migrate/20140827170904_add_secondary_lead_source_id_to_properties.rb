class AddSecondaryLeadSourceIdToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :secondary_lead_source_id, :integer
  end

  def self.down
    remove_column :properties, :secondary_lead_source_id
  end
end
