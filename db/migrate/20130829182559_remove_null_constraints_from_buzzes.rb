class RemoveNullConstraintsFromBuzzes < ActiveRecord::Migration
  def self.up
    change_column :buzzes, :buzzes,       :string, :null => true
    change_column :buzzes, :affiliations, :string, :null => true
  end

  def self.down
    change_column :buzzes, :buzzes,       :string, :null => false
    change_column :buzzes, :affiliations, :string, :null => false
  end
end
