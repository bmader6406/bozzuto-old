require 'test_helper'

module Bozzuto::Searches::Full
  class SearchTest < ActiveSupport::TestCase
    context "Bozzuto::Searches::Full::Search" do
      describe "#values" do
        context "when no input is given" do
          it "returns a ?" do
            subject.values.should == '?'
          end
        end

        context "when input is given" do
          subject { Search.new([10, 5]) }

          before do
            subject.stubs(:main_class).returns(Property)
          end

          it "returns the input transformed into a regex" do
            subject.values.should == "'(5,|5$){1}([[:digit:]]+,|[[:digit:]]+$)*(10,|10$){1}'"
          end
        end
      end
    end
  end
end
