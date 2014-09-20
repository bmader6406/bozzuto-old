require 'test_helper'

class ContactSubmissionTest < ActiveSupport::TestCase
  context "ContactSubmission" do
    subject { ContactSubmission.new }

    [:name, :email, :topic_id, :message].each do |attr|
      it "validates presence of #{attr}" do
        subject.valid?

        subject.errors[attr].should include("can't be blank")
      end
    end
  end
end
