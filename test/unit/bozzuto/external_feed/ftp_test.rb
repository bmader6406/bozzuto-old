require 'test_helper'

module Bozzuto::ExternalFeed
  class FtpTest < ActiveSupport::TestCase
    def tmp_file(name)
      Rails.root.join('tmp', name).to_s
    end

    context "An External Feed FTP" do
      describe ".download_files" do
        before do
          @ftp = mock('Bozzuto::ExternalFeed::Ftp')
          Bozzuto::ExternalFeed::Ftp.expects(:new).returns(@ftp)
        end

        it "calls download file on a new FTP instance" do
          @ftp.expects(:download_files)

          Bozzuto::ExternalFeed::Ftp.download_files
        end
      end

      describe ".transfer" do
        before do
          @ftp = mock('Bozzuto::ExternalFeed::Ftp')
          Bozzuto::ExternalFeed::Ftp.expects(:new).returns(@ftp)

          @file = mock('File')
        end

        it "calls transfer on a new FTP instance with the given file" do
          @ftp.expects(:transfer).with(@file)

          Bozzuto::ExternalFeed::Ftp.transfer(@file)
        end
      end

      describe "#download_files" do
        subject { Bozzuto::ExternalFeed::Ftp.new }

        before do
          @vw_feed  = mock('Bozzuto::ExternalFeed::VaultwareFeed',    :default_file => tmp_file('vw_feed.xml'))
          @rc_feed  = mock('Bozzuto::ExternalFeed::RentCafeFeed',     :default_file => tmp_file('rc_feed.xml'))
          @pl_feed  = mock('Bozzuto::ExternalFeed::PropertyLinkFeed', :default_file => tmp_file('pl_feed.xml'))
          @psi_feed = mock('Bozzuto::ExternalFeed::PsiFeed',          :default_file => tmp_file('psi_feed.xml'))

          Bozzuto::ExternalFeed::Feed.expects(:feed_for_type).with('vaultware').returns(@vw_feed)
          Bozzuto::ExternalFeed::Feed.expects(:feed_for_type).with('rent_cafe').returns(@rc_feed)
          Bozzuto::ExternalFeed::Feed.expects(:feed_for_type).with('property_link').returns(@pl_feed)
          Bozzuto::ExternalFeed::Feed.expects(:feed_for_type).with('psi').returns(@psi_feed)

          @ftp = mock('Net::FTP')
          Net::FTP.expects(:open).with(Bozzuto::ExternalFeed::Ftp::SERVER).yields(@ftp)
        end

        it "sets passive to true, logs into the FTP server, and fetches the file" do
          username = Bozzuto::ExternalFeed::Ftp.username
          password = Bozzuto::ExternalFeed::Ftp.password

          @ftp.expects(:passive=).with(true)
          @ftp.expects(:login).with(username, password)
          @ftp.expects(:getbinaryfile).with('vaultware.xml',    tmp_file('vw_feed.xml'))
          @ftp.expects(:getbinaryfile).with('rentcafe.xml',     tmp_file('rc_feed.xml'))
          @ftp.expects(:getbinaryfile).with('propertylink.xml', tmp_file('pl_feed.xml'))
          @ftp.expects(:getbinaryfile).with('psi.xml',          tmp_file('psi_feed.xml'))

          subject.download_files
        end
      end

      describe "#transfer" do
        subject { Bozzuto::ExternalFeed::Ftp.new }

        before do
          @path = tmp_file('test.txt')
        end

        context "when the given file does not exist" do
          it "raises an error due to a missing file" do
            expect { subject.transfer(@path) }.to raise_error ArgumentError, 'The given file name does not exist.'
          end
        end

        context "when the given file exists" do
          before do
            @ftp = mock('Net::FTP')
            Net::FTP.expects(:open).with(Bozzuto::ExternalFeed::Ftp::SERVER).yields(@ftp)

            @file = File.open(@path, 'w') { |file| file.write('Test') }
          end

          after do
            FileUtils.rm @path
          end

          it "sets passive to true, logs into the FTP server, and transfers the file" do
            username = Bozzuto::ExternalFeed::Ftp.username
            password = Bozzuto::ExternalFeed::Ftp.password

            @ftp.expects(:passive=).with(true)
            @ftp.expects(:login).with(username, password)
            @ftp.expects(:putbinaryfile).with(@path)

            subject.transfer(@path)
          end
        end
      end
    end
  end
end
