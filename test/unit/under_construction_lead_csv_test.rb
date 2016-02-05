require 'test_helper'

module Bozzuto
  class UnderConstructionLeadCsvTest < ActiveSupport::TestCase
    context "UnderConstructionLeadCsv" do
      setup do
        @community = ApartmentCommunity.make(:title => 'Such Community')
        @lead      = UnderConstructionLead.make(:apartment_community => @community,
                                                :address             => '123 Address',
                                                :city                => 'Falls Church',
                                                :state               => 'VA',
                                                :zip_code            => '99999',
                                                :comments            => 'Wow comment',
                                                :address_2           => '2nd address')
      end

      describe "#klass" do
        it "returns UnderConstructionLead" do
          subject = UnderConstructionLeadCsv.new

          assert_equal subject.klass, UnderConstructionLead
        end
      end

      describe "#record_lookup_options" do
        context "when initialized with conditions" do
          it "returns an options hash with the given conditions" do
            options = { :conditions => { test: 'test' } }
            subject = UnderConstructionLeadCsv.new(options)

            subject.record_lookup_options.should == { batch_size: 1000 }
            subject.conditions.should == { test: 'test' }
          end
        end

        context "when initialized with a batch size" do
          it "returns an options hash with the given batch size" do
            options = { :batch_size => 100 }
            subject = UnderConstructionLeadCsv.new(options)

            subject.record_lookup_options.should == { batch_size: 100 }
            subject.conditions.should == {}
          end
        end

        context "when intialized without any custom options" do
          it "returns the default options hash" do
            options = { :conditions => nil, :batch_size => 1000 }
            subject = UnderConstructionLeadCsv.new

            subject.record_lookup_options.should == { batch_size: 1000 }
            subject.conditions.should == {}
          end
        end
      end

      describe "#filename" do
        context "when initialized with a filename" do
          it "returns the given filename" do
            subject = UnderConstructionLeadCsv.new(:filename => 'test.csv')

            subject.filename.should == 'test.csv'
          end
        end

        context "when initialized without a filename" do
          it "returns the default filename" do
            time    = Time.now
            subject = UnderConstructionLeadCsv.new
            subject.stubs(:timestamp).returns(time)

            subject.filename.should == "#{Rails.root}/tmp/export-under_construction_leads-#{time}.csv"
          end
        end
      end

      describe "#string" do
        it "returns all the under construction leads as a csv in string format" do
          subject = UnderConstructionLeadCsv.new

          subject.string.should == csv
        end
      end

      describe "#file" do
        setup do
          @subject = UnderConstructionLeadCsv.new
        end

        teardown do
          FileUtils.rm(@subject.filename)
        end

        it "returns the file path for a csv file with all the under construction leads" do
          file = @subject.file

          File.size(file).should > 0
          subject.filename.should == file
        end
      end
    end

    def csv
      <<-CSV
PropertyName,TheID,PropertyId,Address,City,State,Zip,HomePhone,CellPhone,Email,MoveInDate,DesiredLease,Description,FirstName,LastName,Address2,WorkPhone,DogCount,CatCount,PetNotes,MinPrice,MaxPrice,BedCount,BathCount,FloorplanId,LeadCategoryId,LeadPriorityId,UserId,LeadType,LeadSource,FollowupDate,FollowUpDescription,LeadSourceConduit,Datelog
Such Community,"","",#{@lead.address},#{@lead.city},#{@lead.state},#{@lead.zip_code},#{@lead.phone_number},"",#{@lead.email},"","",#{@lead.comments},#{@lead.first_name},#{@lead.last_name},#{@lead.address_2},"","","","","","","","","","","","","","","","","",#{@lead.created_at}
CSV
    end
  end
end
