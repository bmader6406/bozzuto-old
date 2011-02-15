class AddMobilePhoneNumberToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :mobile_phone_number, :string
  end

  def self.down
    remove_column :properties, :mobile_phone_number
  end
end
