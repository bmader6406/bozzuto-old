class AddExternalCmsTypeFieldToApartments < ActiveRecord::Migration
  def self.up
    add_column :properties, :external_cms_type, :string

    add_index :properties, :external_cms_id
    add_index :properties, [:external_cms_id, :external_cms_type]

    execute "UPDATE properties SET external_cms_type = 'vaultware' WHERE external_cms_id IS NOT NULL"
  end

  def self.down
    remove_column :properties, :external_cms_type

    remove_index :properties, :external_cms_id
    remove_index :properties, [:external_cms_id, :external_cms_type]
  end
end
