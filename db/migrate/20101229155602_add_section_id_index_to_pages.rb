class AddSectionIdIndexToPages < ActiveRecord::Migration
  def self.up
    add_index :pages, :section_id
  end

  def self.down
    remove_index :pages, :section_id
  end
end
