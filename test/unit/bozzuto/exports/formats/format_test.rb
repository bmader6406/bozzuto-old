require 'test_helper'

module Bozzuto::Exports::Formats
  class FormatTest < ActiveSupport::TestCase
    context "Bozzuto::Exports::Formats::Format" do
      describe "#format_float_for_xml" do
        subject { Bozzuto::Exports::Formats::Format.new }

        context "given a non-nil value" do
          it "returns the value as a float" do
            subject.format_float_for_xml(2500.50).should == '2500.5'
          end
        end

        context "given nil" do
          it "returns an empty string" do
            subject.format_float_for_xml(nil).should == ''
          end
        end
      end

      describe "#strip_query_parameters" do
        before do
          @url = 'https://www.bozzuto.com/apartments/100-park?utm_campaign=test&utm_source=bozzuto&random=query'
        end

        it "returns the URL without query parameters" do
          subject.strip_query_parameters(@url).should == 'https://www.bozzuto.com/apartments/100-park'
        end
      end
    end
  end
end
