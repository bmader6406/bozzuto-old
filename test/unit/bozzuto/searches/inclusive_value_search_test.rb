require 'test_helper'

module Bozzuto::Searches
  class InclusiveValueSearchTest < ActiveSupport::TestCase
    context "Bozzuto::Searches::InclusiveValueSearch" do
      describe "#main_class" do
        it "raises a NotImplementedError" do
          expect { subject.main_class }.to raise_error NotImplementedError
        end
      end

      describe "#associated_class" do
        it "raises a NotImplementedError" do
          expect { subject.associated_class }.to raise_error NotImplementedError
        end
      end

      describe "#foreign_key" do
        it "raises a NotImplementedError" do
          expect { subject.foreign_key }.to raise_error NotImplementedError
        end
      end

      describe "#search_column" do
        it "raises a NotImplementedError" do
          expect { subject.search_column }.to raise_error NotImplementedError
        end
      end

      describe "#values" do
        context "when no input is given" do
          it "returns a ?" do
            subject.values.should == '?'
          end
        end

        context "when input is given" do
          subject { InclusiveValueSearch.new([10, 1, 5]) }

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
