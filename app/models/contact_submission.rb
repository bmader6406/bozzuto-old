class ContactSubmission < ActiveRecord::Base
  include Tableless

  column :name,    :string
  column :email,   :string
  column :topic,   :string
  column :message, :text

  TOPICS = [
    ['General Inquiry', 'general_inquiry'],
    ['Apartments',      'apartments'],
    ['New Homes',       'new_homes'],
    ['Acquisitions',    'acquisitions'],
    ['Construction',    'construction'],
    ['Development',     'development'],
    ['Homebuilding',    'homebuilding'],
    ['Land Management', 'land']
  ]
  
  validates_presence_of :name, :email, :topic, :message
end
