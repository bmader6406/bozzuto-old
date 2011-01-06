class RemoveOldLassoColumnsFromProperties < ActiveRecord::Migration
  def self.up
    remove_column :properties, :lasso_uid
    remove_column :properties, :lasso_client_id
    remove_column :properties, :lasso_project_id
  end

  def self.down
    add_column :properties, :lasso_project_id, :string
    add_column :properties, :lasso_client_id, :string
    add_column :properties, :lasso_uid, :string
  end
end
