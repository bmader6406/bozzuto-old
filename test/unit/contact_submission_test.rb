require 'test_helper'

class ContactSubmissionTest < ActiveSupport::TestCase
  context "ContactSubmission" do
    should validate_presence_of(:name)
    should validate_presence_of(:email)
    should validate_presence_of(:topic)
    should validate_presence_of(:message)

    should belong_to(:topic)
  end
end
