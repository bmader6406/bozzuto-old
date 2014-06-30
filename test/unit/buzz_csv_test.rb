require 'test_helper'

module Bozzuto
  class BuzzCsvTest < ActiveSupport::TestCase
    context "BuzzCsv" do
      setup do
        @buzz = Buzz.make(
          :first_name   => 'Bo',
          :last_name    => 'Janglez',
          :street1      => '1st Street',
          :street2      => '2nd Street',
          :city         => 'City',
          :state        => 'State',
          :zip_code     => '99999',
          :phone        => '(123)456-7890',
          :buzzes       => 'such buzz',
          :affiliations => 'very affiliation')
      end

      describe "#klass" do
        it "returns Buzz" do
          subject = BuzzCsv.new

          assert_equal subject.klass, Buzz
        end
      end

      describe "#record_lookup_options" do
        context "when initialized with conditions" do
          it "returns an options hash with the given conditions" do
            subject = BuzzCsv.new(:conditions => 'test')
            options = { :conditions => 'test', :batch_size => 1000 }

            assert_equal subject.record_lookup_options, options
          end
        end

        context "when initialized with a batch size" do
          it "returns an options hash with the given batch size" do
            subject = BuzzCsv.new(:batch_size => 100)
            options = { :conditions => nil, :batch_size => 100 }

            assert_equal subject.record_lookup_options, options
          end
        end

        context "when intialized without any custom options" do
          it "returns the default options hash" do
            subject = BuzzCsv.new
            options = { :conditions => nil, :batch_size => 1000 }

            assert_equal subject.record_lookup_options, options
          end
        end
      end

      describe "#filename" do
        context "when initialized with a filename" do
          it "returns the given filename" do
            subject = BuzzCsv.new(:filename => 'test.csv')

            assert_equal subject.filename, 'test.csv'
          end
        end

        context "when initialized without a filename" do
          it "returns the default filename" do
            time    = Time.now
            subject = BuzzCsv.new
            subject.stubs(:timestamp).returns(time)

            assert_equal subject.filename, "#{Rails.root}/tmp/export-#{Buzz.table_name}-#{time}.csv"
          end
        end
      end

      describe "#string" do
        it "returns all the under construction leads as a csv in string format" do
          subject = BuzzCsv.new

          assert_equal subject.string, csv
        end
      end

      describe "#file" do
        setup do
          @subject = BuzzCsv.new
        end

        teardown do
          FileUtils.rm(@subject.filename)
        end

        it "returns the file path for a csv file with all the buzzes" do
          file = @subject.file

          assert File.size(file) > 0
          assert_equal subject.filename, file
        end
      end
    end

    def csv
      <<-CSV
Email,First Name,Last Name,Street 1,Street 2,City,State,Zip Code,Phone,Buzzes,Affiliations,Created At
#{@buzz.email},#{@buzz.first_name},#{@buzz.last_name},#{@buzz.street1},#{@buzz.street2},#{@buzz.city},#{@buzz.state},#{@buzz.zip_code},#{@buzz.phone},#{@buzz.formatted_buzzes},#{@buzz.formatted_affiliations},#{@buzz.created_at}
CSV
    end
  end
end
