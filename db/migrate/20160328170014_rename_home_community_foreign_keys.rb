class RenameHomeCommunityForeignKeys < ActiveRecord::Migration
  def up
    rename_column :conversion_configurations, :property_id, :home_community_id
    rename_column :lasso_accounts,            :property_id, :home_community_id
  end

  def down
    rename_column :conversion_configurations, :home_community_id, :property_id
    rename_column :lasso_accounts,            :home_community_id, :property_id
  end
end
