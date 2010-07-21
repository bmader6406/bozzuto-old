class AddCachedSlugToLeaders < ActiveRecord::Migration
  def self.up
    add_column :leaders, :cached_slug, :string
    add_index  :leaders, :cached_slug
  end

  def self.down
    remove_column :leaders, :cached_slug
  end
end
