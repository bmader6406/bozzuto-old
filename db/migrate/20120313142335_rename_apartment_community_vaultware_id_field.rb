class RenameApartmentCommunityVaultwareIdField < ActiveRecord::Migration
  def self.up
    rename_column :properties, :vaultware_id, :external_cms_id
  end

  def self.down
    rename_column :properties, :external_cms_id, :vaultware_id
  end
end
