require 'test_helper'

module Bozzuto::Exports
  class ApartmentExportTest < ActiveSupport::TestCase
    context "A Bozzuto::Exports::ApartmentExport" do
      describe ".legacy" do
        it "instantiates the exporter with a Legacy export type" do
          Bozzuto::Exports::Formats::Legacy.expects(:new)

          Bozzuto::Exports::ApartmentExport.legacy
        end
      end

      describe ".mits4_1" do
        it "instantiates the exporter with a MITS 4.1 export type" do
          Bozzuto::Exports::Formats::Mits4_1.expects(:new)

          Bozzuto::Exports::ApartmentExport.mits4_1
        end
      end

      describe "#initialize" do
        context "given an unrecognized format" do
          it "raises an error" do
            expect { Bozzuto::Exports::ApartmentExport.new(:mumbo_jumbo) }.to raise_error
          end
        end
      end

      describe "#to_xml" do
        context "in legacy format" do
          before do
            @format = mock('Bozzuto::Exports::Formats::Legacy')

            Bozzuto::Exports::Formats::Legacy.stubs(:new).returns(@format)
          end

          subject { Bozzuto::Exports::ApartmentExport.new(:legacy) }

          describe "#to_xml" do
            it "shells out to a Legacy format export" do
              @format.expects(:to_xml)

              subject.to_xml
            end
          end
        end

        context "in MITS 4.1 format" do
          before do
            @format = mock('Bozzuto::Exports::Formats::Mits4_1')

            Bozzuto::Exports::Formats::Mits4_1.stubs(:new).returns(@format)
          end

          subject { Bozzuto::Exports::ApartmentExport.new(:mits4_1) }

          describe "#to_xml" do
            it "shells out to a Legacy format export" do
              @format.expects(:to_xml)

              subject.to_xml
            end
          end
        end
      end
    end
  end
end
