class AddPathToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :path, :string
    add_index  :pages, :path

    Page.all.each(&:set_path)
  end

  def self.down
    remove_index  :pages, :path
    remove_column :pages, :path
  end
end
