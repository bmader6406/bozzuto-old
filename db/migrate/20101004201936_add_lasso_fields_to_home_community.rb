class AddLassoFieldsToHomeCommunity < ActiveRecord::Migration
  def self.up
    add_column :properties, :lasso_uid, :string
    add_column :properties, :lasso_client_id, :string
    add_column :properties, :lasso_project_id, :string
  end

  def self.down
    remove_column :properties, :lasso_uid
    remove_column :properties, :lasso_client_id
    remove_column :properties, :lasso_project_id
  end
end
