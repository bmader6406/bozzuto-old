require 'test_helper'

module Bozzuto
  class AdSourceCsvTest < ActiveSupport::TestCase
    context "AdSourceCsv" do
      setup do
        @ad_source_1 = AdSource.make(:domain_name => 'twitter.com', :value => 'SocialMedia')
        @ad_source_2 = AdSource.make(:domain_name => 'google.com',  :value => 'SearchEngine')
      end

      describe "#klass" do
        it "returns AdSource" do
          subject = AdSourceCsv.new

          assert_equal subject.klass, AdSource
        end
      end

      describe "#filename" do
        context "when initialized with a filename" do
          it "returns the given filename" do
            subject = AdSourceCsv.new(:filename => 'test.csv')

            assert_equal subject.filename, 'test.csv'
          end
        end

        context "when initialized without a filename" do
          it "returns the default filename" do
            time    = Time.now
            subject = AdSourceCsv.new
            subject.stubs(:timestamp).returns(time)

            assert_equal subject.filename, "#{Rails.root}/tmp/export-ad_sources-#{time}.csv"
          end
        end
      end

      describe "#string" do
        it "returns all the under construction leads as a csv in string format" do
          subject = AdSourceCsv.new

          assert_equal subject.string, csv
        end
      end

      describe "#file" do
        setup do
          @subject = AdSourceCsv.new
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
Referrer,Ad Source
#{@ad_source_1.domain_name},#{@ad_source_1.value}
#{@ad_source_2.domain_name},#{@ad_source_2.value}
CSV
    end
  end
end
