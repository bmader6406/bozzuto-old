class AddSectionIdToProperty < ActiveRecord::Migration
  def self.up
    add_column :properties, :section_id, :integer
  end

  def self.down
    remove_column :properties, :section_id
  end
end
