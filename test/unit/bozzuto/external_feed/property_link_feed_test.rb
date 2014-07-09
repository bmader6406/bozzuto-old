require 'test_helper'

module Bozzuto::ExternalFeed
  class PropertyLinkFeedTest < ActiveSupport::TestCase
    context "A PropertyLinkFeed" do
      subject { Bozzuto::ExternalFeed::PropertyLinkFeed.new(Rails.root.join('test/files/property_link.xml')) }

      describe "#feed_name" do
        it "returns 'Property Link'" do
          subject.feed_name.should == 'Property Link'
        end
      end

      describe "#properties" do
        it "returns the correct properties" do
          subject.properties.count.should == 2

          subject.properties[0].tap do |c|
            c.title.should             == 'Poplar Glen'
            c.street_address.should    == '11608 Little Patuxent Pkwy'
            c.city.should              == 'Columbia'
            c.state.should             == 'MD'
            c.availability_url.should  == ''
            c.external_cms_id.should   == '90681'
            c.external_cms_type.should == 'property_link'
            c.office_hours.should      == [
              { :open_time => "12:00 PM", :day => "Sunday",    :close_time => "5:00 PM" },
              { :open_time => "9:00 AM",  :day => "Monday",    :close_time => "6:00 PM" },
              { :open_time => "9:00 AM",  :day => "Tuesday",   :close_time => "6:00 PM" },
              { :open_time => "9:00 AM",  :day => "Wednesday", :close_time => "6:00 PM" },
              { :open_time => "9:00 AM",  :day => "Thursday",  :close_time => "6:00 PM" },
              { :open_time => "8:00 AM",  :day => "Friday",    :close_time => "5:00 PM" },
              { :open_time => "10:00 AM", :day => "Saturday",  :close_time => "5:00 PM" }
            ]

            c.floor_plans.count.should == 1

            c.floor_plans[0].tap do |f|
              f.name.should              == 'The Laurel'
              f.available_units.should   == 5
              f.availability_url.should  == ''
              f.bedrooms.should          == 1
              f.bathrooms.should         == 1
              f.min_square_feet.should   == 792
              f.max_square_feet.should   == 792
              f.min_rent.should          == 1250
              f.max_rent.should          == 1530
              f.image_url.should         == 'http://media.propertylinkonline.com/!@!_P2g9MjcyJnc9MzU1JmltZz1odHRwOi8vc3RhdGljLnByb3BlcnR5bGlua29ubGluZS5jb20vdGVtcGxhdGVzL01lZGlhLzc0MTcwODEvOTA2ODEvcGljX2ZwX2NkYzBmNzljLWI5MTYtNGJiOS1iYzJhLTdjNDdlMjVjYzEwNC5qcGc=.jpg'
              f.floor_plan_group.should  == 'one_bedroom'
              f.external_cms_id.should   == '382503'
              f.external_cms_type.should == 'property_link'
            end
          end

          subject.properties[1].tap do |c|
            c.title.should             == 'Park Place at Van Dorn'
            c.street_address.should    == '6001 Archstone Way'
            c.city.should              == 'Alexandria'
            c.state.should             == 'VA'
            c.availability_url.should  == 'http://www.propertylinkonline.com/Availability/Availability.aspx?c=100155&p=106421&r=0'
            c.external_cms_id.should   == '106421'
            c.external_cms_type.should == 'property_link'
            c.office_hours.should      == [
              { :open_time => "12:00 PM", :day => "Sunday",    :close_time => "5:00 PM" },
              { :open_time => "9:00 AM",  :day => "Monday",    :close_time => "6:00 PM" },
              { :open_time => "9:00 AM",  :day => "Tuesday",   :close_time => "6:00 PM" },
              { :open_time => "9:00 AM",  :day => "Wednesday", :close_time => "6:00 PM" },
              { :open_time => "9:00 AM",  :day => "Thursday",  :close_time => "6:00 PM" },
              { :open_time => "8:00 AM",  :day => "Friday",    :close_time => "5:00 PM" },
              { :open_time => "10:00 AM", :day => "Saturday",  :close_time => "5:00 PM" }
            ]

            c.floor_plans.count.should == 2

            c.floor_plans[0].tap do |f|
              f.name.should              == 'Arbor'
              f.availability_url.should  == 'http://www.propertylinkonline.com/Availability/Availability.aspx?c=100155&p=106421&r=579255'
              f.available_units.should   == 0
              f.bedrooms.should          == 1
              f.bathrooms.should         == 1
              f.min_square_feet.should   == 792
              f.max_square_feet.should   == 792
              f.min_rent.should          == 1652
              f.max_rent.should          == 1803
              f.image_url.should         == 'http://capi.myleasestar.com/v2/dimg/9066752/958x1252/9066752.jpg'
              f.floor_plan_group.should  == 'one_bedroom'
              f.external_cms_id.should   == '579255'
              f.external_cms_type.should == 'property_link'
            end

            c.floor_plans[1].tap do |f|
              f.name.should              == 'Birch'
              f.availability_url.should  == 'http://www.propertylinkonline.com/Availability/Availability.aspx?c=100155&p=106421&r=579254'
              f.available_units.should   == 0
              f.bedrooms.should          == 1
              f.bathrooms.should         == 1
              f.min_square_feet.should   == 800
              f.max_square_feet.should   == 800
              f.min_rent.should          == 1657
              f.max_rent.should          == 1807
              f.image_url.should         == 'http://capi.myleasestar.com/v2/dimg/722894/355x324/722894.jpg'
              f.floor_plan_group.should  == 'one_bedroom'
              f.external_cms_id.should   == '579254'
              f.external_cms_type.should == 'property_link'
            end
          end
        end
      end
    end
  end
end
