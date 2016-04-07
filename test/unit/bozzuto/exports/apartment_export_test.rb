require 'test_helper'

module Bozzuto::Exports
  class ApartmentExportTest < ActiveSupport::TestCase
    context "A Bozzuto::Exports::ApartmentExport" do
      describe "#initialize" do
        context "given a legacy-type value" do
          Bozzuto::Exports::Formats::Legacy.expects(:new).twice

          Bozzuto::Exports::ApartmentExport.new('Legacy')
          Bozzuto::Exports::ApartmentExport.new(:legacy)
        end

        context "given an unrecognized format" do
          it "raises an error" do
            expect {
              Bozzuto::Exports::ApartmentExport.new(:mumbo_jumbo)
            }.to raise_error(Bozzuto::Exports::ApartmentExport::UnrecognizedFormatError)
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
      end

      describe "#deliver" do
        context "for a Legacy export" do
          before do
            @format = mock('Bozzuto::Exports::Formats::Legacy')
            @file   = mock('File')

            @format.stubs(:class).returns(Bozzuto::Exports::Formats::Legacy)
            @format.stubs(:to_xml).returns('Legacy')

            Bozzuto::Exports::Formats::Legacy.stubs(:new).returns(@format)

            File.stubs(:open).with(Bozzuto::Exports::Formats::Legacy::PATH, 'w').yields(@file)
          end

          it "writes and transfers the export" do
            @file.expects(:write).with('Legacy')
            Bozzuto::ExternalFeed::QburstFtp.expects(:transfer).with(Bozzuto::Exports::Formats::Legacy::PATH)

            Bozzuto::Exports::ApartmentExport.new(:legacy).deliver
          end
        end
      end
    end
  end
end
