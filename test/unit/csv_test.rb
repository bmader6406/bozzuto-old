require 'test_helper'

module Bozzuto
  class CsvTest < ActiveSupport::TestCase
    context "Csv" do
      subject { Bozzuto::Csv.new }

      describe "#klass" do
        it "raises a NotImplementedError" do
          assert_raises(NotImplementedError) { subject.klass }
        end
      end

      describe "#field_map" do
        it "raises a NotImplementedError" do
          assert_raises(NotImplementedError) { subject.field_map }
        end
      end
    end
  end
end
