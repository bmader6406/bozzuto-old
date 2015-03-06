require 'test_helper'

module Bozzuto::ExternalFeed
  class RentCafeFeedTest < ActiveSupport::TestCase
    context "A RentCafeFeed" do
      subject { Bozzuto::ExternalFeed::RentCafeFeed.new(Rails.root.join('test/files/rent_cafe.xml')) }

      describe "#feed_name" do
        it "returns 'Rent Cafe'" do
          subject.feed_name.should == 'Rent Cafe'
        end
      end

      describe "#properties" do
        it "returns the correct properties" do
          subject.properties.count.should == 2

          subject.properties[0].tap do |c|
            c.title.should             == 'Madox'
            c.street_address.should    == '198 Van Vorst Street'
            c.city.should              == 'Jersey City'
            c.state.should             == 'NJ'
            c.availability_url.should  == 'http://madoxapts.securecafe.com/onlineleasing/madox/oleapplication.aspx?stepname=Apartments&myOlePropertyId=111537'
            c.external_cms_id.should   == 'p0117760'
            c.external_cms_type.should == 'rent_cafe'

            c.office_hours.first.tap do |office_hour|
              office_hour.day.should              == 1
              office_hour.opens_at.should         == '9:00'
              office_hour.opens_at_period.should  == 'AM'
              office_hour.closes_at.should        == '6:00'
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
              f.name.should              == 'A1-2'
              f.availability_url.should  == 'http://madoxapts.securecafe.com/onlineleasing/madox/oleapplication.aspx?stepname=Apartments&myOlePropertyId=111537&floorPlans=858901'
              f.available_units.should   == 0
              f.bedrooms.should          == 1
              f.bathrooms.should         == 1
              f.min_square_feet.should   == 735
              f.max_square_feet.should   == 735
              f.min_rent.should          == 2589
              f.max_rent.should          == 3216
              f.image_url.should         == 'http://www.rentcafe.com/dmslivecafe/3/111537/111537_2_1_81755.jpg'
              f.floor_plan_group.should  == 'one_bedroom'
              f.external_cms_id.should   == '858901'
              f.external_cms_type.should == 'rent_cafe'
            end

            c.floor_plans[1].tap do |f|
              f.name.should              == 'B3-2'
              f.availability_url.should  == 'http://madoxapts.securecafe.com/onlineleasing/madox/oleapplication.aspx?stepname=Apartments&myOlePropertyId=111537&floorPlans=858902'
              f.available_units.should   == 1
              f.bedrooms.should          == 2
              f.bathrooms.should         == 2
              f.min_square_feet.should   == 1057
              f.max_square_feet.should   == 1057
              f.min_rent.should          == 3875
              f.max_rent.should          == 5040
              f.image_url.should         == 'http://www.rentcafe.com/dmslivecafe/3/111537/111537_2_1_81757.jpg'
              f.floor_plan_group.should  == 'two_bedrooms'
              f.external_cms_id.should   == '858902'
              f.external_cms_type.should == 'rent_cafe'
            end
          end

          subject.properties[1].tap do |c|
            c.title.should             == 'The Brownstones at Englewood South'
            c.street_address.should    == '73 Brownstone Way'
            c.city.should              == 'Englewood'
            c.state.should             == 'NJ'
            c.availability_url.should  == 'http://liveatbrownstones.securecafe.com/onlineleasing/the-brownstones-at-englewood-south/oleapplication.aspx?stepname=Apartments&myOlePropertyId=144341'
            c.external_cms_id.should   == 'p0151017'
            c.external_cms_type.should == 'rent_cafe'

            c.office_hours.first.tap do |office_hour|
              office_hour.day.should              == 4
              office_hour.opens_at.should         == '9:00'
              office_hour.opens_at_period.should  == 'AM'
              office_hour.closes_at.should        == '6:00'
              office_hour.closes_at_period.should == 'PM'
            end

            c.office_hours.last.tap do |office_hour|
              office_hour.day.should              == 0
              office_hour.opens_at.should         == '12:00'
              office_hour.opens_at_period.should  == 'PM'
              office_hour.closes_at.should        == '5:00'
              office_hour.closes_at_period.should == 'PM'
            end

            c.floor_plans.count.should == 1

            c.floor_plans[0].tap do |f|
              f.name.should              == 'One Bedroom / One Bath - A1'
              f.availability_url.should  == 'http://liveatbrownstones.securecafe.com/onlineleasing/the-brownstones-at-englewood-south/oleapplication.aspx?stepname=Apartments&myOlePropertyId=144341&floorPlans=937747'
              f.available_units.should   == 3
              f.bedrooms.should          == 1
              f.bathrooms.should         == 1
              f.min_square_feet.should   == 788
              f.max_square_feet.should   == 788
              f.min_rent.should          == 2098
              f.max_rent.should          == 3453
              f.image_url.should         == nil
              f.floor_plan_group.should  == 'one_bedroom'
              f.external_cms_id.should   == '937747'
              f.external_cms_type.should == 'rent_cafe'
            end
          end
        end
      end
    end
  end
end
