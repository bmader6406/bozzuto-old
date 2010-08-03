require 'test_helper'

class ContactTopicTest < ActiveSupport::TestCase
  context 'Contact topic' do
    setup do
      @topic = ContactTopic.make
    end

    subject { @topic }

    should_belong_to :section
    should_have_many :contact_submissions

    should_validate_presence_of :topic, :recipients
    should_validate_uniqueness_of :topic
  end
end
