class ContactSubmission
  include ActiveModel::Model

  attr_accessor :name,
                :email,
                :message,
                :topic_id

  validates :name, :email, :topic_id, :message,
            :presence => true

  validates :email, :email_format => true

  def topic
    ContactTopic.find_by_id(topic_id) if topic_id
  end

  def topic=(new_topic)
    self.topic_id = new_topic.try(:id)
  end

  def attributes
    {
      :name     => name,
      :email    => email,
      :message  => message,
      :topic_id => topic_id
    }
  end
end
