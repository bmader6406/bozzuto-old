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

    describe "building a date from params" do
      context "all date params are presetn" do
        subject do
          Lead2LeaseSubmission.new(
            'move_in_date(1i)' => 2013,
            'move_in_date(2i)' => 1,
            'move_in_date(3i)' => 15
          )
        end

        it "correctly builds the date" do
          subject.move_in_date.should == Date.new(2013, 1, 15)
        end
      end

      context "some date params are missing" do
        subject do
          Lead2LeaseSubmission.new('move_in_date(1i)' => 2013)
        end

        it "has a nil date" do
          subject.move_in_date.should == nil
        end
      end
    end
  end
end
