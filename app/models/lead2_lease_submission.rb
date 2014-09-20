class Lead2LeaseSubmission < ActiveRecord::Base
  has_no_table

  column :first_name, :string
  column :last_name, :string
  column :address_1, :string
  column :address_2, :string
  column :city, :string
  column :state, :string
  column :zip_code, :string
  column :primary_phone, :string
  column :secondary_phone, :string
  column :email, :string
  column :move_in_date, :date
  column :bedrooms, :integer
  column :bathrooms, :integer
  column :pets, :boolean
  column :comments, :text
  column :lead_channel, :string

  validates :email, :first_name, :last_name,
            :presence => true

  validates :email, :email_format => true
end
