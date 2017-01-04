require 'test_helper'

class NotificationRecipientTest < ActiveSupport::TestCase
  context "NotificationRecipient" do
    subject { NotificationRecipient.make(:admin_user, email: 'test@test.com') }

    context "validations" do
      should validate_uniqueness_of(:admin_user_id)
      should validate_uniqueness_of(:email)

      it "is not valid unless an admin user or email address is provided" do
        record = NotificationRecipient.new

        record.valid?.should == false
        record.errors.full_messages.should include 'requires an admin user or an email address.'
      end
    end

    describe ".emails" do
      before do
        NotificationRecipient.make(email: 'other@email.com')
      end

      it "returns the contact emails for all NotificationRecipient records" do
        email = subject.contact_email

        NotificationRecipient.emails.should match_array [email, 'other@email.com']
      end
    end

    describe "#contact_email" do
      context "when the recipient is an admin user" do
        it "returns the email address for the admin user" do
          subject.contact_email.should == subject.admin_user.email
        end
      end

      context "when the recipient is an email address" do
        subject { NotificationRecipient.make(email: 'test@test.com') }

        it "returns the email address" do
          subject.contact_email.should == 'test@test.com'
        end
      end
    end
  end
end
