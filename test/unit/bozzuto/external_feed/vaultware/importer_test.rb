require 'test_helper'

module Bozzuto::ExternalFeed::Vaultware
  class ImporterTest < ActiveSupport::TestCase
    context "A Vaultware Importer" do
      before do
        @file   = ::File.open(Rails.root.join('test/files/vaultware.xml'))
        @import = PropertyFeedImport.make(type: 'vaultware', file: @file)
      end

      subject { Bozzuto::ExternalFeed::Vaultware::Importer.new(@import) }

      describe "#feed_type" do
        it "returns vaultware" do
          subject.feed_type.should == "vaultware"
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
            c.title.should                  == 'Hunters Glen'
            c.street_address.should         == '14210 Slidell Court'
            c.city.should                   == 'Upper Marlboro'
            c.state.should                  == 'MD'
            c.availability_url.should       == 'http://units.realtydatatrust.com/unittype.aspx?ils=5341&propid=14317'
            c.external_cms_id.should        == '14317'
            c.external_cms_type.should      == 'vaultware'
            c.external_management_id.should == '55973'
            c.unit_count.should             == 154

            c.office_hours.first.tap do |office_hour|
              office_hour.day.should              == 1
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

            c.floor_plans.count.should == 2

            c.floor_plans[0].tap do |f|
              f.name.should              == '1 Bedroom 1 Bath'
              f.availability_url.should  == 'http://units.realtydatatrust.com/unitavailability.aspx?ils=5341&fid=9797'
              f.available_units.should   == 3
              f.bedrooms.should          == 1
              f.bathrooms.should         == 1
              f.min_square_feet.should   == 780
              f.max_square_feet.should   == 780
              f.min_rent.should          == 1480
              f.max_rent.should          == 1505
              f.image_url.should         == 'https://cdn.realtydatatrust.com/i/fs/27983'
              f.unit_count.should        == 34
              f.floor_plan_group.should  == 'one_bedroom'
              f.external_cms_id.should   == '9797'
              f.external_cms_type.should == 'vaultware'
            end

            c.floor_plans[1].tap do |f|
              f.name.should              == '1 Bedroom W/Den, 1 Bath'
              f.availability_url.should  == 'http://units.realtydatatrust.com/unitavailability.aspx?ils=5341&fid=9798'
              f.available_units.should   == 1
              f.bedrooms.should          == 1
              f.bathrooms.should         == 1
              f.min_square_feet.should   == 881
              f.max_square_feet.should   == 881
              f.min_rent.should          == 1585
              f.max_rent.should          == 1585
              f.image_url.should         == 'https://cdn.realtydatatrust.com/i/fs/27989'
              f.unit_count.should        == 16
              f.floor_plan_group.should  == 'one_bedroom'
              f.external_cms_id.should   == '9798'
              f.external_cms_type.should == 'vaultware'
            end

            c.property_amenities.count.should == 2

            c.property_amenities.first.tap do |a|
              a.primary_type.should == 'FitnessCenter'
              a.sub_type.should     == nil
              a.description.should  == 'Health club-class fitness center'
              a.position.should     == 1
            end

            c.property_amenities.last.tap do |a|
              a.primary_type.should == 'Garage'
              a.sub_type.should     == 'Both'
              a.description.should  == 'On-site underground parking'
              a.position.should     == 2
            end

            c.apartment_units.count.should == 2

            c.apartment_units.first.tap do |u|
              u.external_cms_id.should              == '12905837'
              u.external_cms_type.should            == 'vaultware'
              u.building_external_cms_id.should     == ''
              u.floorplan_external_cms_id.should    == '9798'
              u.organization_name.should            == nil
              u.marketing_name.should               == '02222'
              u.unit_type.should                    == '2 Bed/1 Bath-Franklin-Aff'
              u.bedrooms.should                     == nil
              u.bathrooms.should                    == nil
              u.min_square_feet.should              == 866
              u.max_square_feet.should              == 866
              u.square_foot_type.should             == nil
              u.unit_rent.should                    == nil
              u.market_rent.should                  == nil
              u.economic_status.should              == nil
              u.economic_status_description.should  == nil
              u.occupancy_status.should             == nil
              u.occupancy_status_description.should == nil
              u.leased_status.should                == 'not ready'
              u.leased_status_description.should    == nil
              u.number_occupants.should             == nil
              u.floor_plan_name.should              == nil
              u.phase_name.should                   == nil
              u.building_name.should                == nil
              u.primary_property_id.should          == '50494'
              u.address_line_1.should               == nil
              u.address_line_2.should               == nil
              u.city.should                         == nil
              u.state.should                        == nil
              u.zip.should                          == nil
              u.avg_rent.should                     == 1314
              u.min_rent.should                     == 1314
              u.max_rent.should                     == 1314
              u.comment.should                      == '02222'
              u.vacate_date.should                  == nil
              u.vacancy_class.should                == 'Occupied'
              u.made_ready_date.should              == nil
              u.availability_url.should             == CGI.unescapeHTML("http://units.realtydatatrust.com/unitavailability.aspx?&amp;ils=5341&amp;propid=50494&amp;fid=102344&amp;uid=12905837")

              u.apartment_unit_amenities.count.should == 0
            end

            c.apartment_units.last.tap do |u|
              u.external_cms_id.should              == '10252429'
              u.external_cms_type.should            == 'vaultware'
              u.building_external_cms_id.should     == ''
              u.floorplan_external_cms_id.should    == '9798'
              u.organization_name.should            == nil
              u.marketing_name.should               == '1010'
              u.unit_type.should                    == '0000004242aa1'
              u.bedrooms.should                     == nil
              u.bathrooms.should                    == nil
              u.min_square_feet.should              == 726
              u.max_square_feet.should              == 726
              u.square_foot_type.should             == nil
              u.unit_rent.should                    == nil
              u.market_rent.should                  == nil
              u.economic_status.should              == nil
              u.economic_status_description.should  == nil
              u.occupancy_status.should             == nil
              u.occupancy_status_description.should == nil
              u.leased_status.should                == 'available'
              u.leased_status_description.should    == nil
              u.number_occupants.should             == nil
              u.floor_plan_name.should              == nil
              u.phase_name.should                   == nil
              u.building_name.should                == nil
              u.primary_property_id.should          == '16992'
              u.address_line_1.should               == nil
              u.address_line_2.should               == nil
              u.city.should                         == nil
              u.state.should                        == nil
              u.zip.should                          == nil
              u.avg_rent.should                     == 2500
              u.min_rent.should                     == 2500
              u.max_rent.should                     == 2734
              u.comment.should                      == '1010'
              u.vacate_date.should                  == Date.new(2015, 3, 31)
              u.vacancy_class.should                == 'Unoccupied'
              u.made_ready_date.should              == nil
              u.availability_url.should             == CGI.unescapeHTML("http://units.realtydatatrust.com/unitavailability.aspx?&amp;ils=5341&amp;propid=16992&amp;fid=20307&amp;uid=10252429")

              u.apartment_unit_amenities.count.should == 3

              u.apartment_unit_amenities[0].tap do |amenity|
                amenity.primary_type.should == 'Other'
                amenity.description.should  == '10th Floor'
                amenity.rank.should         == 1
              end

              u.apartment_unit_amenities[1].tap do |amenity|
                amenity.primary_type.should == 'Other'
                amenity.description.should  == 'Balcony'
                amenity.rank.should         == 2
              end

              u.apartment_unit_amenities[2].tap do |amenity|
                amenity.primary_type.should == 'Other'
                amenity.description.should  == 'Pool View'
                amenity.rank.should         == 3
              end
            end
          end

          subject.data[1].tap do |c|
            c.title.should                  == 'The Courts of Devon'
            c.street_address.should         == '501 Main Street'
            c.city.should                   == 'Gaithersburg'
            c.state.should                  == 'MD'
            c.availability_url.should       == 'http://units.realtydatatrust.com/unittype.aspx?ils=5341&propid=16976'
            c.external_cms_id.should        == '16976'
            c.external_cms_type.should      == 'vaultware'
            c.external_management_id.should == '55973'
            c.unit_count.should             == 253

            c.office_hours.first.tap do |office_hour|
              office_hour.day.should              == 1
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
              f.name.should              == '2 Bedroom/1 Bath'
              f.availability_url.should  == 'http://units.realtydatatrust.com/unitavailability.aspx?ils=5341&fid=20294'
              f.available_units.should   == 5
              f.bedrooms.should          == 2
              f.bathrooms.should         == 1
              f.min_square_feet.should   == 761
              f.max_square_feet.should   == 833
              f.min_rent.should          == 1540
              f.max_rent.should          == 1820
              f.image_url.should         == 'https://cdn.realtydatatrust.com/i/fs/62315'
              f.unit_count.should        == 89
              f.floor_plan_group.should  == 'two_bedrooms'
              f.external_cms_id.should   == '20294'
              f.external_cms_type.should == 'vaultware'
            end

            c.property_amenities.count.should == 2

            c.property_amenities.first.tap do |a|
              a.primary_type.should == 'RecRoom'
              a.sub_type.should     == nil
              a.description.should  == 'high-tech party room with plasma tv and full kitch'
              a.position.should     == 4
            end

            c.property_amenities.last.tap do |a|
              a.primary_type.should == 'TVLounge'
              a.sub_type.should     == nil
              a.description.should  == 'Hip billiards loft'
              a.position.should     == 5
            end

            c.apartment_units.count.should == 2

            c.apartment_units.first.tap do |u|
              u.external_cms_id.should              == '12890066'
              u.external_cms_type.should            == 'vaultware'
              u.building_external_cms_id.should     == ''
              u.floorplan_external_cms_id.should    == '20294'
              u.organization_name.should            == nil
              u.marketing_name.should               == '07132'
              u.unit_type.should                    == '3 Bed/2 Bath Loft-Bristol'
              u.bedrooms.should                     == nil
              u.bathrooms.should                    == nil
              u.min_square_feet.should              == 1463
              u.max_square_feet.should              == 1463
              u.square_foot_type.should             == nil
              u.unit_rent.should                    == nil
              u.market_rent.should                  == nil
              u.economic_status.should              == nil
              u.economic_status_description.should  == nil
              u.occupancy_status.should             == nil
              u.occupancy_status_description.should == nil
              u.leased_status.should                == 'available'
              u.leased_status_description.should    == nil
              u.number_occupants.should             == nil
              u.floor_plan_name.should              == nil
              u.phase_name.should                   == nil
              u.building_name.should                == nil
              u.primary_property_id.should          == '50494'
              u.address_line_1.should               == nil
              u.address_line_2.should               == nil
              u.city.should                         == nil
              u.state.should                        == nil
              u.zip.should                          == nil
              u.avg_rent.should                     == 2395
              u.min_rent.should                     == 2395
              u.max_rent.should                     == 2395
              u.comment.should                      == '07132'
              u.vacate_date.should                  == Date.new(2015, 3, 21)
              u.vacancy_class.should                == 'Unoccupied'
              u.made_ready_date.should              == nil
              u.availability_url.should             == CGI.unescapeHTML("http://units.realtydatatrust.com/unitavailability.aspx?&amp;ils=5341&amp;propid=50494&amp;fid=102339&amp;uid=12890066")

              u.apartment_unit_amenities.count.should == 1

              u.apartment_unit_amenities[0].tap do |amenity|
                amenity.primary_type.should == 'Other'
                amenity.description.should  == 'Wooded View'
                amenity.rank.should         == 2
              end
            end

            c.apartment_units.last.tap do |u|
              u.external_cms_id.should              == '12890112'
              u.external_cms_type.should            == 'vaultware'
              u.building_external_cms_id.should     == ''
              u.floorplan_external_cms_id.should    == '20294'
              u.organization_name.should            == nil
              u.marketing_name.should               == '09028'
              u.unit_type.should                    == '3 Bed/2 Bath Loft-Norfolk-Direct'
              u.bedrooms.should                     == nil
              u.bathrooms.should                    == nil
              u.min_square_feet.should              == 1573
              u.max_square_feet.should              == 1573
              u.square_foot_type.should             == nil
              u.unit_rent.should                    == nil
              u.market_rent.should                  == nil
              u.economic_status.should              == nil
              u.economic_status_description.should  == nil
              u.occupancy_status.should             == nil
              u.occupancy_status_description.should == nil
              u.leased_status.should                == 'not ready'
              u.leased_status_description.should    == nil
              u.number_occupants.should             == nil
              u.floor_plan_name.should              == nil
              u.phase_name.should                   == nil
              u.building_name.should                == nil
              u.primary_property_id.should          == '50494'
              u.address_line_1.should               == nil
              u.address_line_2.should               == nil
              u.city.should                         == nil
              u.state.should                        == nil
              u.zip.should                          == nil
              u.avg_rent.should                     == 3115
              u.min_rent.should                     == 3115
              u.max_rent.should                     == 3115
              u.comment.should                      == '09028'
              u.vacate_date.should                  == nil
              u.vacancy_class.should                == 'Occupied'
              u.made_ready_date.should              == nil
              u.availability_url.should             == CGI.unescapeHTML("http://units.realtydatatrust.com/unitavailability.aspx?&amp;ils=5341&amp;propid=50494&amp;fid=102340&amp;uid=12890112")

              u.apartment_unit_amenities.count.should == 1

              u.apartment_unit_amenities[0].tap do |amenity|
                amenity.primary_type.should == 'Other'
                amenity.description.should  == 'Attached Garage'
                amenity.rank.should         == 1
              end
            end
          end
        end
      end
    end
  end
end
