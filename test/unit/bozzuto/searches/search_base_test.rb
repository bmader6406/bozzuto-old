require 'test_helper'

module Bozzuto::Searches
  class SearchBaseTest < ActiveSupport::TestCase
    context "Bozzuto::Searches::SearchBase" do
      describe ".sql" do
        before do
          @search = mock('Bozzuto::Searches::SearchBase')

          SearchBase.stubs(:new).returns(@search)
        end

        it "instantiates a search and returns the sql" do
          @search.expects(:sql)

          SearchBase.sql
        end
      end

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
          subject { SearchBase.new([10, 1, 5]) }

          it "returns the given input" do
            subject.values.should == '10,1,5'
          end
        end
      end
    end
  end
end
