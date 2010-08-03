class ContactSubmission < ActiveRecord::Base
  has_no_table

  column :name,     :string
  column :email,    :string
  column :message,  :text
  column :topic_id, :integer

  belongs_to :topic, :class_name => 'ContactTopic'

  validates_presence_of :name, :email, :topic, :message
end
