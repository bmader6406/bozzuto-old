require 'test_helper'

class Bozzuto::PhoneNumberTest < ActiveSupport::TestCase
  context "PhoneNumber" do
    describe ".format" do
      context "when given a number containing parentheses" do
        before do
          @number = '(815) 381-3919'
        end

        it "strips out all non-numeric characters" do
          Bozzuto::PhoneNumber.format(@number).should == '8153813919'
        end
      end

      context "when given a number with periods" do
        before do
          @number = '815.381.3919'
        end

        it "strips out all non-numeric characters" do
          Bozzuto::PhoneNumber.format(@number).should == '8153813919'
        end
      end

      context "when given a number greater than 10 digits" do
        before do
          @number = '1-815-381-3919'
        end

        it "strips out all non-numeric characters and only keeps the last 10" do
          Bozzuto::PhoneNumber.format(@number).should == '8153813919'
        end
      end

      context "when given nil" do
        it "returns nil" do
          Bozzuto::PhoneNumber.format(nil).should == nil
        end
      end

      context "when given an empty string" do
        it "returns nil" do
          Bozzuto::PhoneNumber.format('').should == nil
        end
      end
    end

    describe "#to_s" do
      subject { Bozzuto::PhoneNumber.new('8153813919') }

      it "returns a period-separated phone number" do
        subject.to_s.should == '815.381.3919'
      end

      context "when initialized with a blank value" do
        subject { Bozzuto::PhoneNumber.new(nil) }

        it "returns an empty string" do
          subject.to_s.should == ''
        end
      end
    end
  end
end
