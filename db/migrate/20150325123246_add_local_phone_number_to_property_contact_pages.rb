class AddLocalPhoneNumberToPropertyContactPages < ActiveRecord::Migration
  def self.up
    add_column :property_contact_pages, :local_phone_number, :string
  end

  def self.down
    remove_column :property_contact_pages, :local_phone_number
  end
end
