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

        context "given a MITS-type value" do
          it "instantiates the exporter with a MITS 4.1 export type" do
            Bozzuto::Exports::Formats::Mits4_1.expects(:new).twice

            Bozzuto::Exports::ApartmentExport.new('MITS 4.1')
            Bozzuto::Exports::ApartmentExport.new(:mits4_1)
          end
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

        context "for a MITS 4.1 export" do
          before do
            @format = mock('Bozzuto::Exports::Formats::Mits4_1')
            @file   = mock('File')

            @format.stubs(:class).returns(Bozzuto::Exports::Formats::Mits4_1)
            @format.stubs(:to_xml).returns('MITS 4.1')

            Bozzuto::Exports::Formats::Mits4_1.stubs(:new).returns(@format)

            File.stubs(:open).with(Bozzuto::Exports::Formats::Mits4_1::PATH, 'w').yields(@file)

          end

          it "writes and transfers the export" do
            @file.expects(:write).with('MITS 4.1')
            Bozzuto::ExternalFeed::QburstFtp.expects(:transfer).with(Bozzuto::Exports::Formats::Mits4_1::PATH)

            Bozzuto::Exports::ApartmentExport.new(:mits).deliver
          end
        end
      end
    end
  end
end
