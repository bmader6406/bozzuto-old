class AddSnippetIdToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :snippet_id, :integer
  end

  def self.down
    remove_column :pages, :snippet_id
  end
end
