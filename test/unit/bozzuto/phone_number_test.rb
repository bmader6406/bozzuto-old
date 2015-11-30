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
    end
  end
end
