require 'test_helper'

class BozzutoExternalFeedFtpTest < ActiveSupport::TestCase
  class TestFtpClass
    include Bozzuto::ExternalFeed::Ftp
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
