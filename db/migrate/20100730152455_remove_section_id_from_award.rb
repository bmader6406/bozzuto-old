class RemoveSectionIdFromAward < ActiveRecord::Migration
  def self.up
    remove_column :awards, :section_id
  end

  def self.down
    add_column :awards, :section_id, :integer
  end
end
