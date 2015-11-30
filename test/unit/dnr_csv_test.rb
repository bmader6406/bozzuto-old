require 'test_helper'

module Bozzuto
  class DnrCsvTest < ActiveSupport::TestCase
    context "DnrCsv" do
      setup do
        @community_1 = ApartmentCommunity.make(
          :title             => 'Bat-Cave',
          :website_url       => 'http://batcave.com?name=brucewayne',
          :phone_number      => '123 456 7890',
          :dnr_configuration => DnrConfiguration.make_unsaved(:customer_code => 'abc123')
        )
        @community_2 = ApartmentCommunity.make(
          :title             => 'Arkham Asylum',
          :website_url       => 'http://arkham.org',
          :phone_number      => '098 765 4321',
          :dnr_configuration => nil
        )
      end

      describe "#klass" do
        it "returns ApartmentCommunity" do
          subject = DnrCsv.new

          subject.klass.should == ApartmentCommunity
        end
      end

      describe "#filename" do
        context "when initialized with a filename" do
          it "returns the given filename" do
            subject = DnrCsv.new(:filename => 'test.csv')

            assert_equal subject.filename, 'test.csv'
          end
        end

        context "when initialized without a filename" do
          it "returns the default filename" do
            time    = Time.now
            subject = DnrCsv.new
            subject.stubs(:timestamp).returns(time)

            assert_equal subject.filename, "#{Rails.root}/tmp/export-dnr-#{time}.csv"
          end
        end
      end

      describe "#string" do
        it "returns all the under construction leads as a csv in string format" do
          subject = DnrCsv.new

          subject.string.should == csv
        end
      end

      describe "#file" do
        setup do
          @subject = DnrCsv.new
        end

        teardown do
          FileUtils.rm(@subject.filename)
        end

        it "returns the file path for a csv file with all the under construction leads" do
          file = @subject.file

          assert File.size(file) > 0
          assert_equal subject.filename, file
        end
      end
    end

    def csv
      <<-CSV
Title,Website,Phone Number,DNR Account Number,DNR Customer Code
Bat-Cave,http://batcave.com,123.456.7890,1081055,abc123
Arkham Asylum,http://arkham.org,098.765.4321,1081055,""
CSV
    end
  end
end
