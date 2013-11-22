class AddScheduleAppointmentUrlToPropertyContactPages < ActiveRecord::Migration
  def self.up
    add_column :property_contact_pages, :schedule_appointment_url, :string
  end

  def self.down
    remove_column :property_contact_pages, :schedule_appointment_url
  end
end
