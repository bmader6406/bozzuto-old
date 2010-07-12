class AddCachedSlugToProperty < ActiveRecord::Migration
  def self.up
    add_column :properties, :cached_slug, :string
  end

  def self.down
    remove_column :properties, :cached_slug
  end
end
