require 'test_helper'

class ContactSubmissionTest < ActiveSupport::TestCase
  context "ContactSubmission" do
    should_validate_presence_of :name, :email, :topic, :message

    should 'be able to return the formatted topic' do
      topic = ContactSubmission::TOPICS.rand
      submission = ContactSubmission.new :topic => topic[1]
      assert_equal topic[0], submission.formatted_topic
    end
  end
end
