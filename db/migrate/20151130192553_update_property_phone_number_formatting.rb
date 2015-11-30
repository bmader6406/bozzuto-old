class UpdatePropertyPhoneNumberFormatting < ActiveRecord::Migration
  def self.up
    Property.find_each do |property|
      property.update_attributes(
        phone_number:        Bozzuto::PhoneNumber.format(property.phone_number),
        mobile_phone_number: Bozzuto::PhoneNumber.format(property.mobile_phone_number)
      )
    end
  end

  def self.down
    # No op.
  end

  Property = Class.new(ActiveRecord::Base)
end
