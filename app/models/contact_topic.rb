class ContactTopic < ActiveRecord::Base
  acts_as_list

  belongs_to :section

  validates_presence_of :topic, :recipients
  validates_uniqueness_of :topic
end
