require 'test_helper'

module Bozzuto::Searches::Exact
  class SearchTest < ActiveSupport::TestCase
    context "Bozzuto::Searches::Exact::Search" do
      describe "#values" do
        context "when no input is given" do
          it "returns a ?" do
            subject.values.should == '?'
          end
        end

        context "when input is given" do
          subject { Search.new([10, 1, 5]) }

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
