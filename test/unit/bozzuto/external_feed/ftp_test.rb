require 'test_helper'

class BozzutoExternalFeedFtpTest < ActiveSupport::TestCase
  class TestFtpClass
    include Bozzuto::ExternalFeed::Ftp
  end

  context "Bozzuto::ExternalFeed::Ftp" do
    describe ".types" do
      it "returns all the classes under the Bozzuto::ExternalFeed namespace that have included the Ftp module" do
        Bozzuto::ExternalFeed::Ftp.types.should == [
          Bozzuto::ExternalFeed::LiveBozzutoFtp,
          Bozzuto::ExternalFeed::QburstFtp
        ]
      end
    end

    describe ".download_files" do
      context "when there are classes that have included the Ftp module" do
        it "calls #download_files on those classes" do
          Bozzuto::ExternalFeed::LiveBozzutoFtp.expects(:download_files)
          Bozzuto::ExternalFeed::QburstFtp.expects(:download_files)

          Bozzuto::ExternalFeed::Ftp.download_files
        end
      end
    end

    context "An object with the Ftp module mixed in" do
      subject { TestFtpClass.new }

      describe ".transfer" do
        context "with a file that doesn't exist" do
          it "raises an exception" do
            expect {
              TestFtpClass.transfer('blaugh')
            }.to raise_error(ArgumentError)
          end
        end
      end

      describe "#server" do
        it "raises an exception" do
          expect {
            subject.send(:server)
          }.to raise_error(NotImplementedError)
        end
      end

      describe "#feed_types" do
        it "raises an exception" do
          expect {
            subject.send(:feed_types)
          }.to raise_error(NotImplementedError)
        end
      end
    end
  end
end
