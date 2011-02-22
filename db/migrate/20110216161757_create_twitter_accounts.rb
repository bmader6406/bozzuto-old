class CreateTwitterAccounts < ActiveRecord::Migration
  def self.up
    create_table :twitter_accounts do |t|
      t.string :username, :null => false

      t.timestamps
    end

    add_index :twitter_accounts, :username
  end

  def self.down
    remove_index :twitter_accounts, :username

    drop_table :twitter_accounts
  end
end
