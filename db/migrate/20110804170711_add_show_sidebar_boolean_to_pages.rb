class AddShowSidebarBooleanToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :show_sidebar, :boolean, :default => true
  end

  def self.down
    remove_column :pages, :show_sidebar
  end
end
