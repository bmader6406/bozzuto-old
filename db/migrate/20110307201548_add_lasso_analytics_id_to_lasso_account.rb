class AddLassoAnalyticsIdToLassoAccount < ActiveRecord::Migration
  def self.up
    add_column :lasso_accounts, :analytics_id, :string
  end

  def self.down
    remove_column :lasso_accounts, :analytics_id
  end
end
