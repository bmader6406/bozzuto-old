require 'test_helper'

class ContactMailerTest < ActionMailer::TestCase
  context "ContactMailer" do
    setup do
      @submission = ContactSubmission.make_unsaved
    end

    context "#contact_form_submission" do
      setup do
        @email = ContactMailer.deliver_contact_form_submission(@submission)
      end

      should_change('deliveries', :by => 1) { ActionMailer::Base.deliveries.count }

      should "deliver the message" do
        assert_equal [@submission.topic.recipients], @email.to
      end

      should "have a subject" do
        assert_equal "[Bozzuto.com] Message from #{@submission.name}",
          @email.subject
      end

      should "have the user's name and email in the body" do
        assert_match /From: #{@submission.name} <#{@submission.email}>/,
          @email.body
      end
      
      should "have the topic in the body" do
        assert_match /Topic: #{@submission.topic.topic}/, @email.body
      end
    end
  end
end
