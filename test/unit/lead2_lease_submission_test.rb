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

    describe "#attributes" do
      before do
        @attributes = {
          :first_name      => 'First Name',
          :last_name       => 'Last Name',
          :address_1       => 'Address 1',
          :address_2       => 'Address 2',
          :city            => 'City',
          :state           => 'State',
          :zip_code        => 'Zip',
          :primary_phone   => 'Primary Phone',
          :secondary_phone => 'Secondary Phone',
          :email           => 'test@email.com',
          :move_in_date    => Date.new(2015, 1, 21),
          :bedrooms        => 'Bedrooms',
          :bathrooms       => 'Bathrooms',
          :pets            => 'Pets',
          :comments        => 'Comments',
          :lead_channel    => 'Lead Channel'
        }
      end

      subject do
        Lead2LeaseSubmission.new(
          :first_name        => 'First Name',
          :last_name         => 'Last Name',
          :address_1         => 'Address 1',
          :address_2         => 'Address 2',
          :city              => 'City',
          :state             => 'State',
          :zip_code          => 'Zip',
          :primary_phone     => 'Primary Phone',
          :secondary_phone   => 'Secondary Phone',
          :email             => 'test@email.com',
          'move_in_date(1i)' => '2015',
          'move_in_date(2i)' => '1',
          'move_in_date(3i)' => '21',
          :bedrooms          => 'Bedrooms',
          :bathrooms         => 'Bathrooms',
          :pets              => 'Pets',
          :comments          => 'Comments',
          :lead_channel      => 'Lead Channel'
        )
      end

      it "returns a hash of attributes and their values" do
        subject.attributes.should == @attributes
      end
    end
  end
end
