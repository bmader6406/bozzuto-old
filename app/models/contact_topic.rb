class ContactTopic < ActiveRecord::Base
  acts_as_list

  has_friendly_id :topic, :use_slug => true

  belongs_to :section
  has_many :contact_submissions, :foreign_key => :topic_id

  validates_presence_of :topic, :recipients
  validates_uniqueness_of :topic
end
