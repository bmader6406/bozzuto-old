require 'test_helper'

class Lead2LeaseSubmissionTest < ActiveSupport::TestCase
  context "Lead2LeaseSubmission" do
    subject { Lead2LeaseSubmission.new }

    [:email, :first_name, :last_name].each do |attr|
      it "validates presence of #{attr}" do
        subject.valid?

        subject.errors[attr].should include("can't be blank")
      end
    end
  end
end
