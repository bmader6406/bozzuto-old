require 'test_helper'

module Bozzuto
  class ApartmentCommunityFieldAuditTest < ActiveSupport::TestCase
    context "ApartmentCommunityFieldAudit" do
      setup do
        @county = County.make(:name => "Orange")
        @apartment_community = ApartmentCommunity.make({
          :zip_code => '80503',
          :county   => @county,
          :title    => 'Broadmoor Apartments'
        })
        @audit = ApartmentCommunityFieldAudit.new(@apartment_community)
      end
      
      context '#field_value' do
        should "return the correct value for a symbol based field" do
          assert_equal "80503", @audit.field_value(:zip_code)
        end

        should "return the correct value for a lambda based field" do
          assert_equal "Orange", @audit.field_value(lambda {|c| c.county.name })
        end
      end

      context '#field_presence' do
        should 'return "Filled" for a value that is present' do
          assert_equal "Filled", @audit.field_presence(:zip_code)
        end

        should 'return "Empty" for a value that is not there' do
          assert_equal "Empty", @audit.field_presence(:availability_url)
        end
      end

      context '#to_a' do
        setup do
          ApartmentCommunityFieldAudit.stubs(:audit_fields).returns(ActiveSupport::OrderedHash[[
            ["Zip Code",         :zip_code],
            ["Phone Number",     :phone_number],
            ["Availability URL", :availability_url]
          ]])
        end

        should "returns an array with the correct values" do
          assert_equal [@apartment_community.id, @apartment_community.title, "Filled", "Filled", "Empty"],
            @audit.to_a
        end
      end

      context ".audit_csv" do
        setup do
          ApartmentCommunityFieldAudit.stubs(:audit_fields).returns(ActiveSupport::OrderedHash[[
            ["Zip Code",         :zip_code],
            ["County",           lambda {|c| c.county.name }],
            ["Phone Number",     :phone_number],
            ["Availability URL", :availability_url]
          ]])
        end

        should "return the correct CSV string" do
          csv_string = <<-CSV
ID,Title,Zip Code,County,Phone Number,Availability URL
#{@apartment_community.id},Broadmoor Apartments,Filled,Filled,Filled,Empty
CSV
          assert_equal csv_string, ApartmentCommunityFieldAudit.audit_csv
        end
      end

    end
  end
end
