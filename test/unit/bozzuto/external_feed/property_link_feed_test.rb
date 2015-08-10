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

      describe "#process" do
        before do
          create_states
          create_floor_plan_groups
        end

        it "builds property data for each property node from the feed file" do
          subject.process

          subject.data.count.should == 2

          subject.data[0].tap do |c|
            c.title.should                  == 'Poplar Glen'
            c.street_address.should         == '11608 Little Patuxent Pkwy'
            c.city.should                   == 'Columbia'
            c.state.should                  == 'MD'
            c.availability_url.should       == ''
            c.external_cms_id.should        == '90681'
            c.external_cms_type.should      == 'property_link'
            c.external_management_id.should == '7548'
            c.unit_count.should             == 191

            c.office_hours.first.tap do |office_hour|
              office_hour.day.should              == 0
              office_hour.opens_at.should         == '12:00'
              office_hour.opens_at_period.should  == 'PM'
              office_hour.closes_at.should        == '5:00'
              office_hour.closes_at_period.should == 'PM'
            end

            c.office_hours.last.tap do |office_hour|
              office_hour.day.should              == 6
              office_hour.opens_at.should         == '10:00'
              office_hour.opens_at_period.should  == 'AM'
              office_hour.closes_at.should        == '5:00'
              office_hour.closes_at_period.should == 'PM'
            end

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
              f.unit_count.should        == 0
              f.floor_plan_group.should  == 'one_bedroom'
              f.external_cms_id.should   == '382503'
              f.external_cms_type.should == 'property_link'
            end

            c.property_amenities.count.should == 2

            c.property_amenities.first.tap do |a|
              a.primary_type.should == 'Other'
              a.description.should  == "Clary's Forest Pool"
            end

            c.property_amenities.last.tap do |a|
              a.primary_type.should == 'BusinessCenter'
            end

            c.apartment_units.count.should == 1

            c.apartment_units.first.tap do |u|
              u.external_cms_id.should              == '925411918'
              u.external_cms_type.should            == 'property_link'
              u.building_external_cms_id.should     == '11'
              u.floorplan_external_cms_id.should    == '382503'
              u.organization_name.should            == nil
              u.marketing_name.should               == '101'
              u.unit_type.should                    == nil
              u.bedrooms.should                     == 1
              u.bathrooms.should                    == 1
              u.min_square_feet.should              == 792
              u.max_square_feet.should              == 792
              u.square_foot_type.should             == nil
              u.unit_rent.should                    == nil
              u.market_rent.should                  == 1462
              u.economic_status.should              == nil
              u.economic_status_description.should  == nil
              u.occupancy_status.should             == 'vacant'
              u.occupancy_status_description.should == nil
              u.leased_status.should                == 'available'
              u.leased_status_description.should    == nil
              u.number_occupants.should             == nil
              u.floor_plan_name.should              == nil
              u.phase_name.should                   == nil
              u.building_name.should                == nil
              u.primary_property_id.should          == '90681'
              u.address_line_1.should               == nil
              u.address_line_2.should               == nil
              u.city.should                         == nil
              u.state.should                        == nil
              u.zip.should                          == nil
              u.avg_rent.should                     == nil
              u.min_rent.should                     == nil
              u.max_rent.should                     == nil
              u.comment.should                      == '11'
              u.vacate_date.should                  == nil
              u.vacancy_class.should                == 'Unoccupied'
              u.made_ready_date.should              == Date.new(2013, 12, 10)
              u.availability_url.should             == nil
            end
          end

          subject.data[1].tap do |c|
            c.title.should                  == 'Park Place at Van Dorn'
            c.street_address.should         == '6001 Archstone Way'
            c.city.should                   == 'Alexandria'
            c.state.should                  == 'VA'
            c.availability_url.should       == 'http://www.propertylinkonline.com/Availability/Availability.aspx?c=100155&p=106421&r=0'
            c.external_cms_id.should        == '106421'
            c.external_cms_type.should      == 'property_link'
            c.external_management_id.should == '12570719'
            c.unit_count.should             == 285

            c.office_hours.first.tap do |office_hour|
              office_hour.day.should              == 0
              office_hour.opens_at.should         == '12:00'
              office_hour.opens_at_period.should  == 'PM'
              office_hour.closes_at.should        == '5:00'
              office_hour.closes_at_period.should == 'PM'
            end

            c.office_hours.last.tap do |office_hour|
              office_hour.day.should              == 6
              office_hour.opens_at.should         == '10:00'
              office_hour.opens_at_period.should  == 'AM'
              office_hour.closes_at.should        == '5:00'
              office_hour.closes_at_period.should == 'PM'
            end

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
              f.unit_count.should        == 0
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
              f.unit_count.should        == 0
              f.floor_plan_group.should  == 'one_bedroom'
              f.external_cms_id.should   == '579254'
              f.external_cms_type.should == 'property_link'
            end

            c.apartment_units.count.should == 1

            c.apartment_units.first.tap do |u|
              u.external_cms_id.should              == '925921122'
              u.external_cms_type.should            == 'property_link'
              u.building_external_cms_id.should     == ''
              u.floorplan_external_cms_id.should    == '579254'
              u.organization_name.should            == nil
              u.marketing_name.should               == '09O'
              u.unit_type.should                    == nil
              u.bedrooms.should                     == 0
              u.bathrooms.should                    == 1
              u.min_square_feet.should              == 523
              u.max_square_feet.should              == 523
              u.square_foot_type.should             == nil
              u.unit_rent.should                    == nil
              u.market_rent.should                  == 3472
              u.economic_status.should              == nil
              u.economic_status_description.should  == nil
              u.occupancy_status.should             == 'occupied'
              u.occupancy_status_description.should == nil
              u.leased_status.should                == 'on notice'
              u.leased_status_description.should    == nil
              u.number_occupants.should             == nil
              u.floor_plan_name.should              == nil
              u.phase_name.should                   == nil
              u.building_name.should                == nil
              u.primary_property_id.should          == '93392'
              u.address_line_1.should               == nil
              u.address_line_2.should               == nil
              u.city.should                         == nil
              u.state.should                        == nil
              u.zip.should                          == nil
              u.avg_rent.should                     == nil
              u.min_rent.should                     == nil
              u.max_rent.should                     == nil
              u.comment.should                      == ''
              u.vacate_date.should                  == nil
              u.vacancy_class.should                == 'Occupied'
              u.made_ready_date.should              == Date.new(2015, 10, 9)
              u.availability_url.should             == nil
              u.include_in_export.should            == true
            end

            c.property_amenities.count.should == 2

            c.property_amenities.first.tap do |a|
              a.primary_type.should == 'Other'
              a.description.should  == 'BBQ/Picnic Area'
            end

            c.property_amenities.last.tap do |a|
              a.primary_type.should == 'Availability24Hours'
              a.description.should  == '24-Hour Availability'
            end
          end
        end
      end
    end
  end
end
