class AddAboutFlagToSection < ActiveRecord::Migration
  def self.up
    add_column :sections, :about, :boolean, :default => false, :null => false
    add_index :sections, :about
  end

  def self.down
    remove_column :sections, :about
  end
end
