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
            c.unit_count.should        == 0

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
              f.unit_count.should        == 1
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
              f.unit_count.should        == 4
              f.floor_plan_group.should  == 'two_bedrooms'
              f.external_cms_id.should   == '858902'
              f.external_cms_type.should == 'rent_cafe'
            end

            c.property_amenities.count.should == 6

            c.property_amenities.first.tap do |a|
              a.primary_type.should == 'ClubHouse'
            end

            c.property_amenities.last.tap do |a|
              a.primary_type.should == 'OnSiteManagement'
            end

            c.apartment_units.count.should == 2

            c.apartment_units.first.tap do |u|
              u.external_cms_id.should              == '605'
              u.external_cms_type.should            == 'rent_cafe'
              u.building_external_cms_id.should     == '49741'
              u.floorplan_external_cms_id.should    == '858901'
              u.organization_name.should            == nil
              u.marketing_name.should               == nil
              u.unit_type.should                    == '297-3752'
              u.bedrooms.should                     == 1
              u.bathrooms.should                    == 1
              u.min_square_feet.should              == 665
              u.max_square_feet.should              == 665
              u.square_foot_type.should             == 'Internal'
              u.unit_rent.should                    == 2318
              u.market_rent.should                  == 2604
              u.economic_status.should              == 'residential'
              u.economic_status_description.should  == 'residential'
              u.occupancy_status.should             == 'Occupied No Notice'
              u.leased_status.should                == 'Occupied No Notice'
              u.leased_status_description.should    == 'Occupied No Notice'
              u.number_occupants.should             == nil
              u.floor_plan_name.should              == 'A3-2'
              u.phase_name.should                   == nil
              u.building_name.should                == nil
              u.primary_property_id.should          == '111537'
              u.address_line_1.should               == nil
              u.address_line_2.should               == nil
              u.city.should                         == nil
              u.state.should                        == nil
              u.zip.should                          == nil
              u.avg_rent.should                     == nil
              u.min_rent.should                     == nil
              u.max_rent.should                     == nil
              u.comment.should                      == nil
              u.vacate_date.should                  == nil
              u.vacancy_class.should                == nil
              u.made_ready_date.should              == nil
              u.availability_url.should             == CGI.unescapeHTML("http://madoxapts.securecafe.com/onlineleasing/madox/oleapplication.aspx?stepname=RentalOptions&amp;myOlePropertyId=111537&amp;header=1&amp;FloorPlanID=858907&amp;UnitID=708798")

              u.apartment_unit_amenities.count.should == 3

              u.apartment_unit_amenities[0].tap do |amenity|
                amenity.primary_type.should == 'Other'
                amenity.description.should  == '6th Floor'
              end

              u.apartment_unit_amenities[1].tap do |amenity|
                amenity.primary_type.should == 'Other'
                amenity.description.should  == 'Courtyard View'
              end

              u.apartment_unit_amenities[2].tap do |amenity|
                amenity.primary_type.should == 'Other'
                amenity.description.should  == 'Rent'
              end

              u.files.count.should == 1

              u.files.first.tap do |file|
                file.external_cms_id.should   == '605'
                file.external_cms_type.should == 'rent_cafe'
                file.active.should            == true
                file.file_type.should         == 'Other'
                file.description.should       == ''
                file.name.should              == '3_340120_1833937'
                file.caption.should           == ''
                file.format.should            == 'image/jpeg'
                file.source.should            == 'http://cdn.rentcafe.com/dmslivecafe/3/340670/3_340120_1833937.jpg'
                file.width.should             == 0
                file.height.should            == 0
                file.rank.should              == '3'
                file.ad_id.should             == ''
                file.affiliate_id.should      == ''
              end
            end

            c.apartment_units.last.tap do |u|
              u.external_cms_id.should              == '521'
              u.external_cms_type.should            == 'rent_cafe'
              u.building_external_cms_id.should     == '49734'
              u.floorplan_external_cms_id.should    == '858901'
              u.organization_name.should            == nil
              u.marketing_name.should               == nil
              u.unit_type.should                    == '297-3782'
              u.bedrooms.should                     == 0
              u.bathrooms.should                    == 1
              u.min_square_feet.should              == 480
              u.max_square_feet.should              == 480
              u.square_foot_type.should             == 'Internal'
              u.unit_rent.should                    == 2047
              u.market_rent.should                  == 2047
              u.economic_status.should              == 'residential'
              u.economic_status_description.should  == 'residential'
              u.occupancy_status.should             == 'Occupied No Notice'
              u.leased_status.should                == 'Occupied No Notice'
              u.leased_status_description.should    == 'Occupied No Notice'
              u.number_occupants.should             == nil
              u.floor_plan_name.should              == 'A0'
              u.phase_name.should                   == nil
              u.building_name.should                == nil
              u.primary_property_id.should          == '111537'
              u.address_line_1.should               == nil
              u.address_line_2.should               == nil
              u.city.should                         == nil
              u.state.should                        == nil
              u.zip.should                          == nil
              u.avg_rent.should                     == nil
              u.min_rent.should                     == nil
              u.max_rent.should                     == nil
              u.comment.should                      == nil
              u.vacate_date.should                  == nil
              u.vacancy_class.should                == nil
              u.made_ready_date.should              == nil
              u.availability_url.should             == CGI.unescapeHTML("http://madoxapts.securecafe.com/onlineleasing/madox/oleapplication.aspx?stepname=RentalOptions&amp;myOlePropertyId=111537&amp;header=1&amp;FloorPlanID=858903&amp;UnitID=708791")

              u.apartment_unit_amenities.count.should == 2

              u.apartment_unit_amenities[0].tap do |amenity|
                amenity.primary_type.should == 'Other'
                amenity.description.should  == '5th Floor'
              end

              u.apartment_unit_amenities[1].tap do |amenity|
                amenity.primary_type.should == 'Other'
                amenity.description.should  == 'Rent'
              end

              u.files.count.should == 2

              u.files.first.tap do |file|
                file.external_cms_id.should   == '521'
                file.external_cms_type.should == 'rent_cafe'
                file.active.should            == true
                file.file_type.should         == 'Other'
                file.description.should       == ''
                file.name.should              == '3_345611_1385175'
                file.caption.should           == ''
                file.format.should            == 'image/jpeg'
                file.source.should            == 'http://cdn.rentcafe.com/dmslivecafe/3/340670/3_345611_1385175.jpg'
                file.width.should             == 0
                file.height.should            == 0
                file.rank.should              == '4'
                file.ad_id.should             == ''
                file.affiliate_id.should      == ''
              end

              u.files.last.tap do |file|
                file.external_cms_id.should   == '521'
                file.external_cms_type.should == 'rent_cafe'
                file.active.should            == true
                file.file_type.should         == 'Photo'
                file.description.should       == ''
                file.name.should              == '3_121387_1218990'
                file.caption.should           == ''
                file.format.should            == 'image/jpeg'
                file.source.should            == 'http://cdn.rentcafe.com/dmslivecafe/3/111537/3_121387_1218990.jpg'
                file.width.should             == 0
                file.height.should            == 0
                file.rank.should              == '9'
                file.ad_id.should             == ''
                file.affiliate_id.should      == ''
              end
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
            c.unit_count.should        == 0

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
              f.unit_count.should        == 74
              f.floor_plan_group.should  == 'one_bedroom'
              f.external_cms_id.should   == '937747'
              f.external_cms_type.should == 'rent_cafe'
            end

            c.property_amenities.count.should == 7

            c.property_amenities.first.tap do |a|
              a.primary_type.should == 'FitnessCenter'
            end

            c.property_amenities.last.tap do |a|
              a.primary_type.should == 'RecRoom'
            end

            c.apartment_units.count.should == 2

            c.apartment_units.first.tap do |u|
              u.external_cms_id.should              == '09-207'
              u.external_cms_type.should            == 'rent_cafe'
              u.building_external_cms_id.should     == '24613'
              u.floorplan_external_cms_id.should    == '937747'
              u.organization_name.should            == nil
              u.marketing_name.should               == nil
              u.unit_type.should                    == '297-1562'
              u.bedrooms.should                     == 1
              u.bathrooms.should                    == 1
              u.min_square_feet.should              == 788
              u.max_square_feet.should              == 788
              u.square_foot_type.should             == 'Internal'
              u.unit_rent.should                    == 1828
              u.market_rent.should                  == 1813
              u.economic_status.should              == 'residential'
              u.economic_status_description.should  == 'residential'
              u.occupancy_status.should             == 'Vacant'
              u.leased_status.should                == 'available'
              u.leased_status_description.should    == 'Occupied No Notice'
              u.number_occupants.should             == nil
              u.floor_plan_name.should              == 'One Bedroom / One Bath - A1'
              u.phase_name.should                   == nil
              u.building_name.should                == nil
              u.primary_property_id.should          == '144341'
              u.address_line_1.should               == nil
              u.address_line_2.should               == nil
              u.city.should                         == nil
              u.state.should                        == nil
              u.zip.should                          == nil
              u.avg_rent.should                     == nil
              u.min_rent.should                     == nil
              u.max_rent.should                     == nil
              u.comment.should                      == nil
              u.vacate_date.should                  == nil
              u.vacancy_class.should                == nil
              u.made_ready_date.should              == nil
              u.availability_url.should             == CGI.unescapeHTML("http://liveatbrownstones.securecafe.com/onlineleasing/the-brownstones-at-englewood-south/oleapplication.aspx?stepname=RentalOptions&amp;myOlePropertyId=144341&amp;header=1&amp;FloorPlanID=937747&amp;UnitID=1230276")

              u.apartment_unit_amenities.count.should == 1

              u.apartment_unit_amenities[0].tap do |amenity|
                amenity.primary_type.should == 'Other'
                amenity.description.should  == 'Rent'
              end

              u.files.count.should == 2

              u.files.first.tap do |file|
                file.external_cms_id.should   == '09-207'
                file.external_cms_type.should == 'rent_cafe'
                file.active.should            == true
                file.file_type.should         == 'Other'
                file.description.should       == ''
                file.name.should              == '3_340670_1885137'
                file.caption.should           == ''
                file.format.should            == 'image/jpeg'
                file.source.should            == 'http://cdn.rentcafe.com/dmslivecafe/3/340670/3_340670_1885137.jpg'
                file.width.should             == 0
                file.height.should            == 0
                file.rank.should              == '3'
                file.ad_id.should             == ''
                file.affiliate_id.should      == ''
              end

              u.files.last.tap do |file|
                file.external_cms_id.should   == '09-207'
                file.external_cms_type.should == 'rent_cafe'
                file.active.should            == true
                file.file_type.should         == 'Other'
                file.description.should       == ''
                file.name.should              == '3_340670_1885141'
                file.caption.should           == ''
                file.format.should            == 'image/jpeg'
                file.source.should            == 'http://cdn.rentcafe.com/dmslivecafe/3/340670/3_340670_1885141.jpg'
                file.width.should             == 0
                file.height.should            == 0
                file.rank.should              == '4'
                file.ad_id.should             == ''
                file.affiliate_id.should      == ''
              end
            end

            c.apartment_units.last.tap do |u|
              u.external_cms_id.should              == '09-209'
              u.external_cms_type.should            == 'rent_cafe'
              u.building_external_cms_id.should     == '24614'
              u.floorplan_external_cms_id.should    == '937747'
              u.organization_name.should            == nil
              u.marketing_name.should               == nil
              u.unit_type.should                    == '297-1562'
              u.bedrooms.should                     == 1
              u.bathrooms.should                    == 1
              u.min_square_feet.should              == 788
              u.max_square_feet.should              == 788
              u.square_foot_type.should             == 'Internal'
              u.unit_rent.should                    == 1592
              u.market_rent.should                  == 1828
              u.economic_status.should              == 'residential'
              u.economic_status_description.should  == 'residential'
              u.occupancy_status.should             == 'Vacant'
              u.leased_status.should                == 'available'
              u.leased_status_description.should    == 'Occupied No Notice'
              u.number_occupants.should             == nil
              u.floor_plan_name.should              == 'One Bedroom / One Bath - A1'
              u.phase_name.should                   == nil
              u.building_name.should                == nil
              u.primary_property_id.should          == '144341'
              u.address_line_1.should               == nil
              u.address_line_2.should               == nil
              u.city.should                         == nil
              u.state.should                        == nil
              u.zip.should                          == nil
              u.avg_rent.should                     == nil
              u.min_rent.should                     == nil
              u.max_rent.should                     == nil
              u.comment.should                      == nil
              u.vacate_date.should                  == nil
              u.vacancy_class.should                == nil
              u.made_ready_date.should              == nil
              u.availability_url.should             == CGI.unescapeHTML("http://liveatbrownstones.securecafe.com/onlineleasing/the-brownstones-at-englewood-south/oleapplication.aspx?stepname=RentalOptions&amp;myOlePropertyId=144341&amp;header=1&amp;FloorPlanID=937747&amp;UnitID=1230277")

              u.apartment_unit_amenities.count.should == 2

              u.apartment_unit_amenities[0].tap do |amenity|
                amenity.primary_type.should == 'Other'
                amenity.description.should  == 'New Kitchen Countertops'
              end

              u.apartment_unit_amenities[1].tap do |amenity|
                amenity.primary_type.should == 'Other'
                amenity.description.should  == 'Rent'
              end

              u.files.count.should == 1

              u.files.first.tap do |file|
                file.external_cms_id.should   == '09-209'
                file.external_cms_type.should == 'rent_cafe'
                file.active.should            == true
                file.file_type.should         == 'Photo'
                file.description.should       == ''
                file.name.should              == '3_111537_1778084'
                file.caption.should           == ''
                file.format.should            == 'image/jpeg'
                file.source.should            == 'http://cdn.rentcafe.com/dmslivecafe/3/111537/3_111537_1778084.jpg'
                file.width.should             == 0
                file.height.should            == 0
                file.rank.should              == '9'
                file.ad_id.should             == ''
                file.affiliate_id.should      == ''
              end
            end
          end
        end
      end
    end
  end
end
