class AddNextUpdateAtToTwitterAccounts < ActiveRecord::Migration
  def self.up
    add_column :twitter_accounts, :next_update_at, :datetime

    now = Time.now.utc.strftime('%Y-%m-%d %H:%M:%S')
    execute "UPDATE twitter_accounts SET next_update_at = '#{now}'"

    change_column :twitter_accounts, :next_update_at, :datetime, :null => false
  end

  def self.down
    remove_column :twitter_accounts, :next_update_at
  end
end
