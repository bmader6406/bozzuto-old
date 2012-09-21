class AddShowInSidebarNavToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :show_in_sidebar_nav, :boolean, :default => true
    execute "UPDATE pages SET show_in_sidebar_nav = true"
  end

  def self.down
    remove_column :pages, :show_in_sidebar_nav
  end
end
