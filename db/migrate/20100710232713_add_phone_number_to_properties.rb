class AddPhoneNumberToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :phone_number, :string
  end

  def self.down
    remove_column :properties, :phone_number
  end
end
