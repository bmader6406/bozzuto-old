require 'test_helper'

class ContactTopicTest < ActiveSupport::TestCase
  context 'Contact topic' do
    subject { ContactTopic.make }

    should belong_to(:section)
    should have_many(:contact_submissions)

    should validate_presence_of(:topic)
    should validate_presence_of(:recipients)
    should validate_uniqueness_of(:topic)
  end
end
