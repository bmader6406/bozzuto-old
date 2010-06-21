class AddCachedSlugToSection < ActiveRecord::Migration
  def self.up
    add_column :sections, :cached_slug, :string
    add_index  :sections, :cached_slug
  end

  def self.down
    remove_column :sections, :cached_slug
  end
end
