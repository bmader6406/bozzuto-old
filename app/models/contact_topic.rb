class ContactTopic < ActiveRecord::Base
  include FriendlyId

  acts_as_list

  friendly_id :topic, use: [:slugged]

  belongs_to :section

  validates_presence_of :topic, :recipients
  validates_uniqueness_of :topic
end
