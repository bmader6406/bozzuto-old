require 'test_helper'

class ContactSubmissionTest < ActiveSupport::TestCase
  context "ContactSubmission" do
    should_validate_presence_of :name, :email, :topic, :message
  end
end
