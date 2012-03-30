class AddCommentsFieldToUnderConstructionLead < ActiveRecord::Migration
  def self.up
    add_column :under_construction_leads, :comments, :text
  end

  def self.down
    remove_column :under_construction_leads, :comments
  end
end
