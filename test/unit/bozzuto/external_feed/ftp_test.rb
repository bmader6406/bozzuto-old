require 'test_helper'

module Bozzuto::ExternalFeed
  class FtpTest < ActiveSupport::TestCase
    def default_file
      Rails.root.join('tmp', 'vaultware_feed.xml')
    end

    context "An External Feed FTP" do
      describe "initialization" do
        before do
          @feed = mock('Bozzuto::ExternalFeed::Vaultware', :default_file => default_file)
          Bozzuto::ExternalFeed::Feed.expects(:feed_for_type).with(:vaultware).returns(@feed)
        end

        subject { Bozzuto::ExternalFeed::Ftp.new(:vaultware) }

        it "sets the feed type" do
          expect(subject.feed_type).to eq :vaultware
        end

        it "sets the target location based on the feed type" do
          expect(subject.target_location).to eq default_file
        end
      end

      describe ".download_file_for" do
        before do
          @ftp = mock('Bozzuto::ExternalFeed::Ftp')
          Bozzuto::ExternalFeed::Ftp.expects(:new).with(:vaultware).returns(@ftp)
        end

        it "calls download file on a new FTP instance" do
          @ftp.expects(:download_file)

          Bozzuto::ExternalFeed::Ftp.download_file_for(:vaultware)
        end
      end

      describe "#download_file" do
        subject { Bozzuto::ExternalFeed::Ftp.new(:vaultware) }

        before do
          @feed = mock('Bozzuto::ExternalFeed::Vaultware', :default_file => default_file)
          Bozzuto::ExternalFeed::Feed.expects(:feed_for_type).with(:vaultware).returns(@feed)

          @ftp = mock('Net::FTP')
          Net::FTP.expects(:open).with('feeds.livebozzuto.com').yields(@ftp)
        end

        it "sets passive to true, logs into the FTP server, and fetches the file" do
          username = Bozzuto::ExternalFeed::Ftp.username
          password = Bozzuto::ExternalFeed::Ftp.password

          @ftp.expects(:passive=).with(true)
          @ftp.expects(:login).with(username, password)
          @ftp.expects(:getbinaryfile).with('vaultware.xml', default_file)

          subject.download_file
        end
      end
    end
  end
end
