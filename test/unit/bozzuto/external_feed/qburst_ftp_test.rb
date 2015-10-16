require 'test_helper'

module Bozzuto::ExternalFeed
  class FtpTest < ActiveSupport::TestCase
    def tmp_file(name)
      Rails.root.join('test', 'files', name).to_s
    end

    context "An External Feed FTP" do
      describe ".ftp_name" do
        it "returns the correct FTP name" do
          Bozzuto::ExternalFeed::QburstFtp.ftp_name.should == 'Qburst'
        end
      end

      describe ".download_files" do
        before do
          @ftp = mock('Bozzuto::ExternalFeed::Ftp')
          Bozzuto::ExternalFeed::QburstFtp.expects(:new).returns(@ftp)
        end

        it "calls download file on a new FTP instance" do
          @ftp.expects(:download_files)

          Bozzuto::ExternalFeed::QburstFtp.download_files
        end
      end

      describe "#download_files" do
        subject { Bozzuto::ExternalFeed::QburstFtp.new }

        before do
          @path        = tmp_file('carmel.xml')
          @carmel_feed = mock('Bozzuto::ExternalFeed::CarmelFeed', :default_file => @path)

          Bozzuto::ExternalFeed::Feed.expects(:feed_for_type).with('carmel').returns(@carmel_feed)

          @ftp = mock('Net::FTP')

          Net::FTP.expects(:open).with('bozzutofeed.qburst.com').yields(@ftp)

          subject.expects(:can_load?).returns(true)
        end


        it "sets passive to true, logs into the FTP server, and fetches the file" do
          username = Bozzuto::ExternalFeed::QburstFtp.username
          password = Bozzuto::ExternalFeed::QburstFtp.password

          @ftp.expects(:passive=).with(true)
          @ftp.expects(:login).with(username, password)
          @ftp.expects(:getbinaryfile).with('Carmel.xml', @path)

          subject.download_files
        end
      end

      describe ".transfer" do
        before do
          @ftp = mock('Bozzuto::ExternalFeed::QburstFtp')
          Bozzuto::ExternalFeed::QburstFtp.expects(:new).returns(@ftp)

          @file = mock('File')
        end

        it "calls transfer on a new FTP instance with the given file" do
          @ftp.expects(:transfer).with(@file)

          Bozzuto::ExternalFeed::QburstFtp.transfer(@file)
        end
      end

      describe "#transfer" do
        subject { Bozzuto::ExternalFeed::QburstFtp.new }

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

            Net::FTP.expects(:open).with('bozzutofeed.qburst.com').yields(@ftp)

            @file = File.open(@path, 'w') { |file| file.write('Test') }
          end

          after do
            FileUtils.rm @path
          end

          it "sets passive to true, logs into the FTP server, and transfers the file" do
            username = Bozzuto::ExternalFeed::QburstFtp.username
            password = Bozzuto::ExternalFeed::QburstFtp.password

            @ftp.expects(:passive=).with(true)
            @ftp.expects(:login).with(username, password)
            @ftp.expects(:putbinaryfile).with(@path)

            subject.transfer(@path)
          end
        end

        describe "#feed_types" do
          subject { Bozzuto::ExternalFeed::QburstFtp.new }

          it "returns the correct set of feed types" do
            subject.feed_types.should == %w(carmel)
          end
        end

        describe "#loading_enabled?" do
          subject { Bozzuto::ExternalFeed::QburstFtp.new }

          it "returns true" do
            subject.loading_enabled?.should == true
          end
        end
      end
    end
  end
end
