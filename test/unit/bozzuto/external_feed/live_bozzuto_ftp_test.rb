require 'test_helper'

module Bozzuto::ExternalFeed
  class LiveBozzutoFtpTest < ActiveSupport::TestCase
    def tmp_file(name)
      Rails.root.join('tmp', name).to_s
    end

    context "A Live Bozzuto External Feed FTP" do
      describe ".download_files" do
        before do
          @ftp = mock('Bozzuto::ExternalFeed::Ftp')
          Bozzuto::ExternalFeed::LiveBozzutoFtp.expects(:new).returns(@ftp)
        end

        it "calls download file on a new FTP instance" do
          @ftp.expects(:download_files)

          Bozzuto::ExternalFeed::LiveBozzutoFtp.download_files
        end
      end

      describe "#download_files" do
        subject { Bozzuto::ExternalFeed::LiveBozzutoFtp.new }

        before do
          @vw_feed     = mock('Bozzuto::ExternalFeed::VaultwareFeed',    :default_file => tmp_file('vw_feed.xml'))
          @rc_feed     = mock('Bozzuto::ExternalFeed::RentCafeFeed',     :default_file => tmp_file('rc_feed.xml'))
          @pl_feed     = mock('Bozzuto::ExternalFeed::PropertyLinkFeed', :default_file => tmp_file('pl_feed.xml'))
          @psi_feed    = mock('Bozzuto::ExternalFeed::PsiFeed',          :default_file => tmp_file('psi_feed.xml'))

          Bozzuto::ExternalFeed::Feed.expects(:feed_for_type).with('vaultware').returns(@vw_feed)
          Bozzuto::ExternalFeed::Feed.expects(:feed_for_type).with('rent_cafe').returns(@rc_feed)
          Bozzuto::ExternalFeed::Feed.expects(:feed_for_type).with('property_link').returns(@pl_feed)
          Bozzuto::ExternalFeed::Feed.expects(:feed_for_type).with('psi').returns(@psi_feed)

          @ftp = mock('Net::FTP')

          Net::FTP.expects(:open).with('feeds.livebozzuto.com').yields(@ftp)
        end

        it "sets passive to true, logs into the FTP server, and fetches the file" do
          username = Bozzuto::ExternalFeed::LiveBozzutoFtp.username
          password = Bozzuto::ExternalFeed::LiveBozzutoFtp.password

          @ftp.expects(:passive=).with(true)
          @ftp.expects(:login).with(username, password)
          @ftp.expects(:getbinaryfile).with('vaultware.xml',    tmp_file('vw_feed.xml'))
          @ftp.expects(:getbinaryfile).with('rentcafe.xml',     tmp_file('rc_feed.xml'))
          @ftp.expects(:getbinaryfile).with('propertylink.xml', tmp_file('pl_feed.xml'))
          @ftp.expects(:getbinaryfile).with('psi.xml',          tmp_file('psi_feed.xml'))

          subject.download_files
        end
      end
    end
  end
end
