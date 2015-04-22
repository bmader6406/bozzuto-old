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
    end
  end
end
