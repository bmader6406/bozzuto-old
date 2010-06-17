require 'test_helper'

class ContactMailerTest < ActionMailer::TestCase
  context "ContactMailer" do
    setup do
      @submission = ContactSubmission.make_unsaved
      @to = APP_CONFIG[:contact_emails][@submission.topic]
    end

    context "#contact_form_submission" do
      setup do
        assert_difference('ActionMailer::Base.deliveries.count', 1) do
          @email = ContactMailer.deliver_contact_form_submission(@submission)
        end
      end

      should "deliver the message" do
        assert_equal [@to], @email.to
      end

      should "have a subject" do
        assert_equal "Message from #{@submission.name}", @email.subject
      end

      should "have the user's name and email in the body" do
        assert_match /From: #{@submission.name} <#{@submission.email}>/,
          @email.body
      end
      
      should "have the formatted topic in the body" do
        assert_match /Topic: #{@submission.formatted_topic}/, @email.body
      end
    end
  end
end
