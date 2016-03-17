require 'test_helper'

module Bozzuto::ExternalFeed
  class ImporterTest < ActiveSupport::TestCase

    class MockImporter < Bozzuto::ExternalFeed::Importer
      def feed_type
        'mock'
      end
    end

    context "An Importer" do

      describe "#initialize" do
        before do
          @feed = mock("PropertyFeedImport")
          @feed.stubs(:queued?).returns(false)
          @feed.stubs(:state).returns("failure")
        end

        it "raises an error if the feed is not queued" do
          expect {
            MockImporter.new(@feed)
          }.to raise_error(ArgumentError)
        end
      end

      describe "#call" do
        before do
          @file = ::File.open("test/files/psi.xml")
          @feed = mock("PropertyFeedImport")
          @feed.stubs(:file).returns(@file)
          @feed.stubs(:queued?).returns(true)

          @parser = mock("Bozzuto::ExternalFeed::XmlParser")
          @parser.stubs(:parse)
          Bozzuto::ExternalFeed::XmlParser.stubs(:new).returns(@parser)
        end

        subject { MockImporter.new(@feed) }

        it "marks the feed as processing" do
          @feed.expects(:mark_as_processing)
          @feed.stubs(:mark_as_success)

          subject.call
        end

        context "on success" do
          it "marks the feed as success" do
            @feed.stubs(:mark_as_processing)
            @feed.expects(:mark_as_success)

            subject.call
          end
        end

        context "on failure" do
          it "marks the feed as failure" do
            @feed.stubs(:mark_as_processing)
            @feed.expects(:mark_as_failure)

            @parser.stubs(:parse).raises(StandardError)

            subject.call
          end
        end
      end
    end
  end
end
