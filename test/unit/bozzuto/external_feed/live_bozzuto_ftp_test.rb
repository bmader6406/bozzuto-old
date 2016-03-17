require 'test_helper'

module Bozzuto::ExternalFeed
  class LiveBozzutoFtpTest < ActiveSupport::TestCase
    context "A Live Bozzuto External Feed FTP" do
      describe ".ftp_name" do
        it "returns the correct FTP name" do
          Bozzuto::ExternalFeed::LiveBozzutoFtp.ftp_name.should == 'Live Bozzuto'
        end
      end

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
          @ftp = mock('Net::FTP')

          Net::FTP.expects(:open).with('feeds.livebozzuto.com').yields(@ftp)

          subject.expects(:can_load?).returns(true)

          APP_CONFIG[:vaultware_feed_file]     = "test/files/vaultware.xml"
          APP_CONFIG[:property_link_feed_file] = "test/files/property_link.xml"
          APP_CONFIG[:rent_cafe_feed_file]     = "test/files/rent_cafe.xml"
          APP_CONFIG[:psi_feed_file]           = "test/files/psi.xml"
        end

        it "sets passive to true, logs into the FTP server, and fetches the file" do
          username = Bozzuto::ExternalFeed::LiveBozzutoFtp.username
          password = Bozzuto::ExternalFeed::LiveBozzutoFtp.password

          @ftp.expects(:passive=).with(true)
          @ftp.expects(:login).with(username, password)
          @ftp.expects(:getbinaryfile).with("vaultware.xml",    "test/files/vaultware.xml")
          @ftp.expects(:getbinaryfile).with("rentcafe.xml",     "test/files/rent_cafe.xml")
          @ftp.expects(:getbinaryfile).with('propertylink.xml', "test/files/property_link.xml")
          @ftp.expects(:getbinaryfile).with('psi.xml',          "test/files/psi.xml")

          subject.download_files
        end
      end

      describe "#feed_types" do
        subject { Bozzuto::ExternalFeed::LiveBozzutoFtp.new }

        it "returns the appropriate feed types" do
          subject.feed_types.should =~ %w(vaultware property_link psi rent_cafe)
        end
      end
    end
  end
end
