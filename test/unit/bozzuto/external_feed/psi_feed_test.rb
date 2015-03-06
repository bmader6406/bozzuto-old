require 'test_helper'

module Bozzuto::ExternalFeed
  class PsiFeedTest < ActiveSupport::TestCase
    context "A PsiFeed" do
      subject { Bozzuto::ExternalFeed::PsiFeed.new(Rails.root.join('test/files/psi.xml')) }

      describe "#feed_name" do
        it "returns 'PSI'" do
          subject.feed_name.should == 'PSI'
        end
      end

      describe "#properties" do
        it "returns the correct properties" do
          subject.properties.count.should == 2

          subject.properties[0].tap do |c|
            c.title.should             == 'Madox'
            c.street_address.should    == '198 Van Vorst St'
            c.city.should              == 'Jersey City'
            c.state.should             == 'NJ'
            c.availability_url.should  == 'http://madox.prospectportal.com/Apartments/module/property_info/property[id]/49989'
            c.external_cms_id.should   == '49989'
            c.external_cms_type.should == 'psi'

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
              f.floor_plan_group.should  == 'one_bedroom'
              f.external_cms_id.should   == '184745'
              f.external_cms_type.should == 'psi'
            end
          end

          subject.properties[1].tap do |c|
            c.title.should             == 'Palette at Arts District'
            c.street_address.should    == '5501 45th Ave'
            c.city.should              == 'Hyattsville'
            c.state.should             == 'MD'
            c.availability_url.should  == 'http://paletteatarts.prospectportal.com/Apartments/module/property_info/property[id]/49990'
            c.external_cms_id.should   == '49990'
            c.external_cms_type.should == 'psi'
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
              f.floor_plan_group.should  == 'one_bedroom'
              f.external_cms_id.should   == '189005'
              f.external_cms_type.should == 'psi'
            end
          end
        end
      end
    end
  end
end
