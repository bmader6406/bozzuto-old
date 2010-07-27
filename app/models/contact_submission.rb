class ContactSubmission < ActiveRecord::Base
  has_no_table

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
    ['Land',            'land'],
    ['Management',      'management']
  ]
  
  validates_presence_of :name, :email, :topic, :message


  def formatted_topic
    TOPICS.rassoc(topic).first
  end
end
