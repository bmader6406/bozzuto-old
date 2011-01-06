class CreateLassoAccounts < ActiveRecord::Migration
  def self.up
    create_table :lasso_accounts do |t|
      t.integer :property_id, :null => false
      t.string :uid, :null => false
      t.string :client_id, :null => false
      t.string :project_id, :null => false
      t.timestamps
    end
    add_index :lasso_accounts, :property_id
  end

  def self.down
    drop_table :lasso_accounts
  end
end