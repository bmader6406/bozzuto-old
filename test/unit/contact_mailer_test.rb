require 'test_helper'

class ContactMailerTest < ActionMailer::TestCase
  context "ContactMailer" do
    before do
      @submission = ContactSubmission.make_unsaved
    end

    describe "#contact_form_submission" do
      before do
        expect {
          @email = ContactMailer.contact_form_submission(@submission).deliver_now
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it "sends to the correct recipients" do
        @email.to.should == [@submission.topic.recipients]
      end

      it "has the correct subject" do
        @email.subject.should == "[Bozzuto.com] Message from #{@submission.name}"
      end

      it "has the user's name and email in the body" do
        @email.encoded.should =~ /From: #{@submission.name} <#{@submission.email}>/
      end
      
      it "has the topic in the body" do
        @email.body.should =~ /Topic: #{@submission.topic.topic}/
      end
    end
  end
end
