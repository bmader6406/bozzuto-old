require 'test_helper'

module Bozzuto::ExternalFeed::Psi
  class ImporterTest < ActiveSupport::TestCase
    context "A Psi Importer" do
      before do
        @file   = ::File.open(Rails.root.join('test/files/psi.xml'))
        @import = PropertyFeedImport.make(type: "psi", file: @file)
      end

      subject { Bozzuto::ExternalFeed::Psi::Importer.new(@import) }

      describe "#feed_type" do
        it "returns psi" do
          subject.feed_type.should == "psi"
        end
      end

      describe "#call" do
        before do
          create_states
          create_floor_plan_groups
        end

        it "creates properties" do
          subject.call

          subject.data.count.should == 2

          subject.data[0].tap do |c|
            c.title.should             == 'Madox'
            c.street_address.should    == '198 Van Vorst St'
            c.city.should              == 'Jersey City'
            c.state.should             == 'NJ'
            c.availability_url.should  == 'http://madox.prospectportal.com/Apartments/module/property_info/property[id]/49989'
            c.external_cms_id.should   == '49989'
            c.external_cms_type.should == 'psi'
            c.unit_count.should        == 131

            c.office_hours.first.tap do |office_hour|
              office_hour.day.should              == 1
              office_hour.opens_at.should         == '9:00'
              office_hour.opens_at_period.should  == 'AM'
              office_hour.closes_at.should        == '6:00'
              office_hour.closes_at_period.should == 'PM'
            end

            c.office_hours.last.tap do |office_hour|
              office_hour.day.should              == 0
              office_hour.opens_at.should         == '9:00'
              office_hour.opens_at_period.should  == 'AM'
              office_hour.closes_at.should        == '5:00'
              office_hour.closes_at_period.should == 'PM'
            end

            c.floor_plans.count.should == 2

            c.floor_plans[0].tap do |f|
              f.name.should              == 'A0'
              f.availability_url.should  == 'http://madox.prospectportal.com/Apartments/module/property_info/property[id]/49989/launch_guest_card/1/property_floorplan[id]/184743'
              f.available_units.should   == 0
              f.bedrooms.should          == 0
              f.bathrooms.should         == 1
              f.min_square_feet.should   == 480
              f.max_square_feet.should   == 480
              f.min_rent.should          == 0
              f.max_rent.should          == 0
              f.image_url.should         == 'https://medialibrarycdn.propertysolutions.com/media_library/4346/507d837124123567.jpg'
              f.unit_count.should        == 0
              f.floor_plan_group.should  == 'studio'
              f.external_cms_id.should   == '184743'
              f.external_cms_type.should == 'psi'
            end

            c.floor_plans[1].tap do |f|
              f.name.should              == 'A10'
              f.availability_url.should  == 'http://madox.prospectportal.com/Apartments/module/property_info/property[id]/49989/launch_guest_card/1/property_floorplan[id]/184745'
              f.available_units.should   == 0
              f.bedrooms.should          == 1
              f.bathrooms.should         == 1
              f.min_square_feet.should   == 1018
              f.max_square_feet.should   == 1018
              f.min_rent.should          == 0
              f.max_rent.should          == 0
              f.image_url.should         == 'https://medialibrarycdn.propertysolutions.com/media_library/4346/507d83cc5f062493.jpg'
              f.unit_count.should        == 0
              f.floor_plan_group.should  == 'one_bedroom'
              f.external_cms_id.should   == '184745'
              f.external_cms_type.should == 'psi'
            end

            c.property_amenities.count.should == 2

            c.property_amenities.first.tap do |a|
              a.primary_type.should == 'Other'
              a.description.should  == '24 Hour Fitness Gym'
            end

            c.property_amenities.last.tap do |a|
              a.primary_type.should == 'Other'
              a.description.should  == 'Bike Storage'
            end
          end

          subject.data[1].tap do |c|
            c.title.should             == 'Palette at Arts District'
            c.street_address.should    == '5501 45th Ave'
            c.city.should              == 'Hyattsville'
            c.state.should             == 'MD'
            c.availability_url.should  == 'http://paletteatarts.prospectportal.com/Apartments/module/property_info/property[id]/49990'
            c.external_cms_id.should   == '49990'
            c.external_cms_type.should == 'psi'
            c.unit_count.should        == 243
            c.office_hours.should      == []

            c.floor_plans.count.should == 1

            c.floor_plans[0].tap do |f|
              f.name.should              == 'A1'
              f.availability_url.should  == 'http://paletteatarts.prospectportal.com/Apartments/module/property_info/property[id]/49990/launch_guest_card/1/property_floorplan[id]/189005'
              f.available_units.should   == 0
              f.bedrooms.should          == 1
              f.bathrooms.should         == 1
              f.min_square_feet.should   == 0
              f.max_square_feet.should   == 0
              f.min_rent.should          == 0
              f.max_rent.should          == 0
              f.image_url.should         == 'https://medialibrarycdn.propertysolutions.com/media_library/4346/5098331813558971.jpg'
              f.unit_count.should        == 0
              f.floor_plan_group.should  == 'one_bedroom'
              f.external_cms_id.should   == '189005'
              f.external_cms_type.should == 'psi'
            end

            c.property_amenities.count.should == 0

            c.apartment_units.count.should == 1

            c.apartment_units.first.tap do |u|
              u.external_cms_id.should              == '3438936'
              u.external_cms_type.should            == 'psi'
              u.building_external_cms_id.should     == '0'
              u.floorplan_external_cms_id.should    == '250870'
              u.organization_name.should            == '2102'
              u.marketing_name.should               == '3F'
              u.unit_type.should                    == '2 Bedroom 1 Bath'
              u.bedrooms.should                     == 2
              u.bathrooms.should                    == 1
              u.min_square_feet.should              == 874
              u.max_square_feet.should              == 874
              u.square_foot_type.should             == 'internal'
              u.unit_rent.should                    == 3995
              u.market_rent.should                  == 3995
              u.economic_status.should              == ''
              u.economic_status_description.should  == ''
              u.occupancy_status.should             == 'vacant'
              u.occupancy_status_description.should == ''
              u.leased_status.should                == ''
              u.leased_status_description.should    == ''
              u.number_occupants.should             == 0
              u.floor_plan_name.should              == '878 Sqft 2 Bed 1 Bath'
              u.phase_name.should                   == ''
              u.building_name.should                == ''
              u.primary_property_id.should          == nil
              u.address_line_1.should               == '111 Kent Avenue'
              u.address_line_2.should               == '3F'
              u.city.should                         == 'Brooklyn'
              u.state.should                        == 'NY'
              u.zip.should                          == '11249'
              u.avg_rent.should                     == 3995
              u.min_rent.should                     == 3995
              u.max_rent.should                     == 3995
              u.comment.should                      == nil
              u.vacate_date.should                  == Date.new(2015, 1, 9)
              u.vacancy_class.should                == 'Unoccupied'
              u.made_ready_date.should              == nil
              u.availability_url.should             == "http://kntst.prospectportal.com/Apartments/module/property_info/property[id]/72414/launch_check_availability/1/property_floorplan[id]/250870/property_unit[id]/3438936"
            end
          end
        end
      end
    end
  end
end
