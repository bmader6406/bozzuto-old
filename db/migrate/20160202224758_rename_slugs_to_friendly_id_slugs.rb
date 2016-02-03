class RenameSlugsToFriendlyIdSlugs < ActiveRecord::Migration
  def change
    rename_table  :slugs, :friendly_id_slugs
    rename_column :friendly_id_slugs, :name, :slug
  end
end
