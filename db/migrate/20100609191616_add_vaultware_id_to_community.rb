class AddVaultwareIdToCommunity < ActiveRecord::Migration
  def self.up
    add_column :communities, :vaultware_id, :integer
  end

  def self.down
    add_column :communities, :vaultware_id
  end
end
