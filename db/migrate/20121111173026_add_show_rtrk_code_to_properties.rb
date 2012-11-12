class AddShowRtrkCodeToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :show_rtrk_code, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :properties, :show_rtrk_code
  end
end
