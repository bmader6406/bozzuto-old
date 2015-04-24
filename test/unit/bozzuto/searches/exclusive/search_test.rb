require 'test_helper'

module Bozzuto::Searches::Exclusive
  class SearchTest < ActiveSupport::TestCase
    context "Bozzuto::Searches::Exclusive::Search" do
      describe "#values" do
        context "when no input is given" do
          it "returns a ?" do
            subject.values.should == '?'
          end
        end

        context "when input is given" do
          subject { ExclusiveValueSearch.new([10, 1, 5]) }

          before do
            subject.stubs(:main_class).returns(Property)
          end

          it "returns a SQL-sanitized string of values" do
            subject.values.should == "'1,5,10'"
          end
        end
      end
    end
  end
end
