require 'test_helper'

module Bozzuto::ExternalFeed
  class FtpTest < ActiveSupport::TestCase
    def tmp_file(name)
      Rails.root.join('tmp', name).to_s
    end

    context "An External Feed FTP" do
      describe ".transfer" do
        before do
          @ftp = mock('Bozzuto::ExternalFeed::OutboundFtp')
          Bozzuto::ExternalFeed::OutboundFtp.expects(:new).returns(@ftp)

          @file = mock('File')
        end

        it "calls transfer on a new FTP instance with the given file" do
          @ftp.expects(:transfer).with(@file)

          Bozzuto::ExternalFeed::OutboundFtp.transfer(@file)
        end
      end

      describe "#transfer" do
        subject { Bozzuto::ExternalFeed::OutboundFtp.new }

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
            Net::FTP.expects(:open).with(Bozzuto::ExternalFeed::OutboundFtp::SERVER).yields(@ftp)

            @file = File.open(@path, 'w') { |file| file.write('Test') }
          end

          after do
            FileUtils.rm @path
          end

          it "sets passive to true, logs into the FTP server, and transfers the file" do
            username = Bozzuto::ExternalFeed::OutboundFtp.username
            password = Bozzuto::ExternalFeed::OutboundFtp.password

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
