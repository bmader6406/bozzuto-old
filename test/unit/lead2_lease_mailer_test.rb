require 'test_helper'

class Lead2LeaseMailerTest < ActionMailer::TestCase
  context "Lead2LeaseMailer" do
    setup do
      @lead = Lead2LeaseSubmission.make_unsaved
      @community = ApartmentCommunity.make(:lead_2_lease_email => Faker::Internet.email)
    end

    describe "#contact_form_submission" do
      before do
        expect {
          @email = Lead2LeaseMailer.submission(@community, @lead).deliver_now
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it "delivers the message to the correct recipient" do
        @email.to.should == [@community.lead_2_lease_email]
      end

      it "uses the submission email as the reply to" do
        @email.reply_to.should == [@lead.email]
      end

      it "has a subject" do
        @email.subject.should == "--New Email Lead For #{@community.title}--"
      end

      it "contains the email address" do
        @email.body.should =~ /Email Address: #{@lead.email}/
      end
    end
  end
end
