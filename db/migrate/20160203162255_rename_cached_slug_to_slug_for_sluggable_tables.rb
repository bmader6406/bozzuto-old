class RenameCachedSlugToSlugForSluggableTables < ActiveRecord::Migration
  def change
    rename_column :areas,               :cached_slug, :slug
    rename_column :home_neighborhoods,  :cached_slug, :slug
    rename_column :landing_pages,       :cached_slug, :slug
    rename_column :leaders,             :cached_slug, :slug
    rename_column :metros,              :cached_slug, :slug
    rename_column :neighborhoods,       :cached_slug, :slug
    rename_column :pages,               :cached_slug, :slug
    rename_column :project_categories,  :cached_slug, :slug
    rename_column :properties,          :cached_slug, :slug
    rename_column :sections,            :cached_slug, :slug

    add_index :landing_pages, :slug
    add_index :pages,         :slug
    add_index :properties,    :slug
  end
end
