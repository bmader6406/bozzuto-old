require 'test_helper'

module Bozzuto::Exports::Formats
  class Mits4_1Test < ActiveSupport::TestCase
    context "Bozzuto::Exports::Formats::Mits4_1" do
      describe ".to_s" do
        it "returns the format name" do
          Bozzuto::Exports::Formats::Mits4_1.to_s.should == 'MITS 4.1'
        end
      end

      describe "#to_xml" do
        before do
          state  = State.make(:name => 'North Carolina', :code => 'NC')
          county = County.make(:name => 'Dawnguard', :state => state)
          city   = City.make(:name => 'Bogsville', :state => state, :counties => [county])

          twitter_account = TwitterAccount.new(:username => 'TheBozzutoGroup')
          twitter_account.save(:validate => false)

          @overview_text = %q{
            <p>
              <em>dolan haev u seen pluto?</em>
              i jsut find him<br />
              yay where is he?
            </p>
          }

          @community = ApartmentCommunity.make(
            :core_id                 => 999,
            :title                   => 'Dolans Hood',
            :street_address          => '100 Gooby Pls',
            :city                    => city,
            :zip_code                => '89223',
            :county                  => county,
            :lead_2_lease_email      => 'dolan@pls.org',
            :phone_number            => '832.382.1337',
            :video_url               => 'http://www.videoapt.com/208/LibertyTowers/Default.aspx',
            :overview_text           => @overview_text,
            :overview_bullet_1       => 'ovrvu bulet 1',
            :overview_bullet_2       => 'ovrvu bulet 2',
            :overview_bullet_3       => 'ovrvu bulet 3',
            :facebook_url            => 'http://facebook.com/dafuq',
            :twitter_account         => twitter_account,
            :pinterest_url           => 'http://pinterest.com/bozzuto',
            :website_url             => 'http://what.up',
            :latitude                => 0.0,
            :longitude               => 45.0,
            :listing_image_file_name => 'test.jpg',
            :meta_description        => 'wow wow wee wah',
            :unit_count              => 25,
            :availability_url        => 'http://wow-so-available.com',
            :external_cms_id         => '123',
            :external_management_id  => '1337'
          )

          @office_hours = [
            OfficeHour.make(
              :property  => @community,
              :day       => 1,
              :opens_at  => '8:00',
              :closes_at => '6:00'
            ),
            OfficeHour.make(
              :property  => @community,
              :day       => 6,
              :opens_at  => '10:00',
              :closes_at => '4:00'
            )
          ]

          @rec_room = PropertyAmenity.make(
            :property     => @community,
            :primary_type => 'RecRoom',
            :description  => 'Such room'
          )

          @garage = PropertyAmenity.make(
            :property     => @community,
            :primary_type => 'Garage',
            :sub_type     => 'Both',
            :description  => 'Parking available both above and below ground.'
          )

          @feature1 = PropertyFeature.make(:name => 'Feature Uno', :position => 1, :apartment_communities => [@community])
          @feature2 = PropertyFeature.make(:name => 'Feature Due', :position => 2, :apartment_communities => [@community])

          @slideshow  = PropertySlideshow.make(:property => @community)
          @slide      = PropertySlide.make(:property_slideshow => @slideshow)
          @floor_plan = ApartmentFloorPlan.make(
            :apartment_community => @community,
            :name                => 'The Roxy',
            :availability_url    => 'http://lol.wut',
            :available_units     => 3,
            :image_file_name     => 'test.jpg',
            :image_type          => ApartmentFloorPlan::USE_IMAGE_FILE,
            :bedrooms            => 3,
            :bathrooms           => 2,
            :min_square_feet     => 1400,
            :max_square_feet     => 1400,
            :min_rent            => 2260,
            :max_rent            => 2300,
            :unit_count          => 5,
            :external_cms_id     => '456'
          )

          @unit = ApartmentUnit.make(
            :floor_plan                   => @floor_plan,
            :organization_name            => 'Org',
            :marketing_name               => '5A',
            :unit_type                    => 'Awesome',
            :bedrooms                     => 2.0,
            :bathrooms                    => 1.5,
            :min_square_feet              => 850,
            :max_square_feet              => 1025,
            :square_foot_type             => 'internal',
            :unit_rent                    => 2500,
            :market_rent                  => 2600,
            :economic_status              => 'Economic Status',
            :economic_status_description  => 'Economic Status Description',
            :occupancy_status             => 'Occupancy Status',
            :leased_status                => 'Leased Status',
            :leased_status_description    => 'Leased Status Description',
            :number_occupants             => 2,
            :floor_plan_name              => '2 BR 1.5 Bath',
            :phase_name                   => 'Rise to Greatness',
            :building_name                => 'Roxy North',
            :primary_property_id          => '123',
            :address_line_1               => 'Address Line 1',
            :address_line_2               => 'Address Line 2',
            :city                         => 'City',
            :state                        => 'State',
            :zip                          => 'Zip',
            :comment                      => 'Comment',
            :min_rent                     => 2400,
            :max_rent                     => 2700,
            :avg_rent                     => 2550,
            :vacate_date                  => Date.new(2015, 12, 25),
            :vacancy_class                => 'Occupied',
            :made_ready_date              => Date.new(2016, 1, 1),
            :availability_url             => 'http://availability.com',
            :external_cms_id              => '789'
          )

          @ac = ApartmentUnitAmenity.make(
            :apartment_unit => @unit,
            :primary_type   => 'AirConditioner',
            :sub_type       => 'Central',
            :description    => 'such cool',
            :rank           => 1
          )

          @unit_file = FeedFile.make(
            :feed_record  => @unit,
            :name         => '5A Kitchen',
            :source       => 'http://images.com/unit-5A-kitchen.jpg',
            :ad_id        => 'Ad ID',
            :affiliate_id => 'Affiliate ID',
            :rank         => '1'
          )

          @community.reload
          @community.save

          @excluded = ApartmentCommunity.make(:excluded_from_export, :city => city)

          PropertyNeighborhoodPage.make({
            :property => @community,
            :content  => 'wilcum to da hood'
          })

          @xml = Nokogiri::XML(Bozzuto::Exports::Formats::Mits4_1.new.to_xml)
        end

        it "contains PhysicalProperty node" do
          @xml.xpath("//PhysicalProperty").present?.should == true
        end

        context "within the Property node" do
          before do
            @property_node = @xml.xpath("//PhysicalProperty/Property").first
          end

          it "contains the property id" do
            @property_node['IDValue'].to_i.should == 999
          end

          context "within PropertyID node" do
            before do
              @property_id_node = @xml.xpath('//PhysicalProperty//Property//PropertyID').first
            end

            it "contains the management sync ID" do
              @property_id_node.xpath('SyncMgmtID').first.content.should == @community.external_management_id
            end

            it "contains the property sync ID" do
              @property_id_node.xpath('SyncPropertyID').first.content.should == @community.external_cms_id
            end

            it "contains the marketing name" do
              @property_id_node.xpath('MarketingName').first.content.should == @community.title
            end

            it "contains the property website" do
              @property_id_node.xpath('WebSite').first.content.should == @community.website_url
            end

            it "contains the email" do
              @property_id_node.xpath('Email').first.content.should == @community.lead_2_lease_email
            end

            context "within the Phone node" do
              before do
                @phone_node = @property_id_node.xpath('Phone').first
              end

              it "has the appropriate phone type" do
                @phone_node['PhoneType'].should == 'office'
              end

              it "contains the phone number" do
                @phone_node.xpath('PhoneNumber').first.content.should == '832.382.1337'
              end
            end

            context "within the Address node" do
              before do
                @address_node = @property_id_node.xpath('Address').first
              end

              it "contains the address line 1" do
                @address_node.xpath('AddressLine1').first.content.should == '100 Gooby Pls'
              end

              it "contains the city" do
                @address_node.xpath('City').first.content.should == 'Bogsville'
              end

              it "contains the state" do
                @address_node.xpath('State').first.content.should == 'NC'
              end

              it "contains the postal code" do
                @address_node.xpath('PostalCode').first.content.should == '89223'
              end

              it "contains the county name" do
                @address_node.xpath('CountyName').first.content.should == 'Dawnguard'
              end
            end

            context "within the ILS Identification node" do
              before do
                @ils_identification_node = @property_node.xpath('ILS_Identification').first
              end

              it "has the correct ILS identification type" do
                @ils_identification_node['ILS_IdentificationType'].should == 'Apartment'
              end

              it "has the correct rental type" do
                @ils_identification_node['RentalType'].should == 'Market Rate'
              end

              it "contains the latitude" do
                @ils_identification_node.xpath('Latitude').first.content.should == '0.0'
              end

              it "contains the longitude" do
                @ils_identification_node.xpath('Longitude').first.content.should == '45.0'
              end
            end

            context "within Information node" do
              before do
                @information_node = @property_node.xpath('Information').first
              end

              it "contains the unit count" do
                @information_node.xpath('UnitCount').first.content.should == '25'
              end

              context "within Office Hour node" do
                before do
                  @office_hour_node = @information_node.xpath('OfficeHour').first
                end

                it "contains open time" do
                  @office_hour_node.xpath('OpenTime').first.content.should == '8:00 AM'
                end

                it "contains close time" do
                  @office_hour_node.xpath('CloseTime').first.content.should == '6:00 PM'
                end

                it "contains day" do
                  @office_hour_node.xpath('Day').first.content.should == 'Monday'
                end
              end

              it "contains the short description" do
                @information_node.xpath('ShortDescription').first.content.should == 'wow wow wee wah'
              end

              it "contains the long description" do
                @information_node.xpath('LongDescription').first.content.should == 'dolan haev u seen pluto? i jsut find him yay where is he?'
              end

              it "contains the driving directions" do
                url = 'http://maps.google.com/maps?daddr=100%20Gooby%20Pls,%20Bogsville,%20NC'

                @information_node.xpath('DrivingDirections').first.content.should == url
              end

              it "contains the property availability URL" do
                @information_node.xpath('PropertyAvailabilityURL').first.content.should == 'http://wow-so-available.com'
              end
            end
          end

          context "within a Floor Plan node" do
            before do
              @floor_plan_node = @xml.xpath("//PhysicalProperty//Property//Floorplan[@IDValue=\"#{@floor_plan.id}\"]").first
            end

            it "contains the floor plan sync ID" do
              @floor_plan_node.xpath('SyncFloorplanID').first.content.should == @floor_plan.external_cms_id
            end

            it "contains name" do
              @floor_plan_node.xpath('Name').first.content.should == 'The Roxy'
            end

            it "contains the unit count" do
              @floor_plan_node.xpath('UnitCount').first.content.should == '5'
            end

            it "contains availability url" do
              @floor_plan_node.xpath('FloorplanAvailabilityURL').first.content.should == 'http://lol.wut'
            end

            it "contains available units" do
              @floor_plan_node.xpath('DisplayedUnitsAvailable').first.content.should == '3'
            end

            context "within the bedroom Room node" do
              before do
                @bedroom_node = @floor_plan_node.xpath('Room[@RoomType="Bedroom"]').first
              end

              it "contains the count" do
                @bedroom_node.xpath('Count').first.content.should == '3'
              end

              it "contains the comment" do
                @bedroom_node.xpath('Comment').first.content.should == ''
              end
            end

            context "within the bathroom Room node" do
              before do
                @bathroom_node = @floor_plan_node.xpath('Room[@RoomType="Bathroom"]').first
              end

              it "contains the count" do
                @bathroom_node.xpath('Count').first.content.should == '2.0'
              end

              it "contains the comment" do
                @bathroom_node.xpath('Comment').first.content.should == ''
              end
            end

            it "contains minimum square footage" do
              @floor_plan_node.xpath('SquareFeet').first['Min'].should == '1400'
            end

            it "contains maximum square footage" do
              @floor_plan_node.xpath('SquareFeet').first['Max'].should == '1400'
            end

            it "contains min market rent" do
              @floor_plan_node.xpath('MarketRent').first['Min'].should == '2260'
            end

            it "contains max market rent" do
              @floor_plan_node.xpath('MarketRent').first['Max'].should == '2300'
            end

            it "contains minimum effective rent" do
              @floor_plan_node.xpath('EffectiveRent').first['Min'].should == '2260'
            end

            it "contains maximum effective rent" do
              @floor_plan_node.xpath('EffectiveRent').first['Max'].should == '2300'
            end

            context "within its File node" do
              before do
                @file_node = @floor_plan_node.xpath('File').first
              end

              it "has the correct id" do
                @file_node['FileID'].to_i.should == @floor_plan.id
              end

              it "is flagged as active" do
                @file_node['Active'].should == 'true'
              end

              it "contains the file type" do
                @file_node.xpath('FileType').first.content.should == 'Floorplan'
              end

              it "contains the name" do
                @file_node.xpath('Name').first.content.should == 'original.jpg'
              end

              it "contains the format" do
                @file_node.xpath('Format').first.content.should == 'image/jpeg'
              end

              it "contains the source" do
                @file_node.xpath('Src').first.content.should =~ %r{http://bozzuto\.com/system/apartment_floor_plans/\d+/original\.jpg}
              end

              it "contains the rank" do
                @file_node.xpath('Rank').first.content.should == '1'
              end
            end
          end

          context "within an ILS Unit node" do
            before do
              @unit_node = @property_node.xpath('ILS_Unit').first
            end

            it "has the unit id" do
              @unit_node['IDValue'].to_i.should == @unit.id
            end

            context "within the Units node" do
              before do
                @units_node = @unit_node.xpath('Units').first
              end

              it "contains the Unit ID" do
                @units_node.xpath('UnitID').first.content.should == @unit.id.to_s
              end

              it "contains the unit sync ID" do
                @units_node.xpath('SyncUnitID').first.content.should == @unit.external_cms_id
              end

              it "contains the marketing name" do
                @units_node.xpath('MarketingName').first.content.should == '5A'
              end

              it "contains the unit type" do
                @units_node.xpath('UnitType').first.content.should == 'Awesome'
              end

              it "contains the number of bedrooms" do
                @units_node.xpath('UnitBedrooms').first.content.should == '2.0'
              end

              it "contains the number of bathrooms" do
                @units_node.xpath('UnitBathrooms').first.content.should == '1.5'
              end

              it "contains the minimum square feet" do
                @units_node.xpath('MinSquareFeet').first.content.should == '850'
              end

              it "contains the maximum square feet" do
                @units_node.xpath('MaxSquareFeet').first.content.should == '1025'
              end

              it "contains the square foot type" do
                @units_node.xpath('SquareFootType').first.content.should == 'internal'
              end

              it "contains the unit rent" do
                @units_node.xpath('UnitRent').first.content.should == '2500.0'
              end

              it "contains the market rent" do
                @units_node.xpath('MarketRent').first.content.should == '2600.0'
              end

              it "contains the economic status" do
                @units_node.xpath('UnitEconomicStatus').first.content.should == 'Economic Status'
              end

              it "contains the economic status description" do
                @units_node.xpath('UnitEconomicStatusDescription').first.content.should == 'Economic Status Description'
              end

              it "contains the number of occupants" do
                @units_node.xpath('NumberOccupants').first.content.should == '2'
              end

              it "contains the floor plan ID" do
                @units_node.xpath('FloorplanID').first.content.should == @floor_plan.id.to_s
              end

              it "contains the floor plan name" do
                @units_node.xpath('FloorplanName').first.content.should == '2 BR 1.5 Bath'
              end

              it "contains the phase name" do
                @units_node.xpath('PhaseName').first.content.should == 'Rise to Greatness'
              end

              it "contains the building name" do
                @units_node.xpath('BuildingName').first.content.should == 'Roxy North'
              end

              context "within the Address node" do
                before do
                  @address_node = @units_node.xpath('Address').first
                end

                it "has the correct address type" do
                  @address_node['AddressType'].should == 'property'
                end

                it "contains the address line 1" do
                  @address_node.xpath('AddressLine1').first.content.should == 'Address Line 1'
                end

                it "contains the address line 2" do
                  @address_node.xpath('AddressLine2').first.content.should == 'Address Line 2'
                end

                it "contains the city" do
                  @address_node.xpath('City').first.content.should == 'City'
                end

                it "contains the state" do
                  @address_node.xpath('State').first.content.should == 'State'
                end

                it "contains the zip code" do
                  @address_node.xpath('PostalCode').first.content.should == 'Zip'
                end
              end
            end

            it "contains the effective rent values" do
              @unit_node.xpath('EffectiveRent').first.tap do |rent_node|
                rent_node['Avg'].should == '2550.0'
                rent_node['Min'].should == '2400.0'
                rent_node['Max'].should == '2700.0'
              end
            end

            context "within the Availability node" do
              before do
                @availability_node = @unit_node.xpath('Availability').first
              end

              it "contains the vacate date" do
                @availability_node.xpath('VacateDate').first.tap do |date_node|
                  date_node['Month'].should == '12'
                  date_node['Day'].should   == '25'
                  date_node['Year'].should  == '2015'
                end
              end

              it "contains the vacancy class" do
                @availability_node.xpath('VacancyClass').first.content.should == 'Occupied'
              end

              it "contains the made ready date" do
                @availability_node.xpath('MadeReadyDate').first.tap do |date_node|
                  date_node['Month'].should == '1'
                  date_node['Day'].should   == '1'
                  date_node['Year'].should  == '2016'
                end
              end

              it "contains the availability URL" do
                @availability_node.xpath('UnitAvailabilityURL').first.content.should == 'http://availability.com'
              end
            end

            it "contains the comment" do
              @unit_node.xpath('Comment').first.content.should == 'Comment'
            end

            context "within the Amenity node" do
              before do
                @amenity_node = @unit_node.xpath('Amenity').first
              end

              it "has the correct amenity type" do
                @amenity_node['AmenityType'].should == 'AirConditioner'
              end

              it "has the correct amenity sub-type" do
                @amenity_node['AmenitySubType'].should == 'Central'
              end

              it "contains the description" do
                @amenity_node.xpath('Description').first.content.should == 'such cool'
              end

              it "contains the rank" do
                @amenity_node.xpath('Rank').first.content.should == '1'
              end
            end

            context "within its File node" do
              before do
                @file_node = @unit_node.xpath('File').first
              end

              it "has the correct id" do
                @file_node['FileID'].to_i.should == @floor_plan.id
              end

              it "is flagged as active" do
                @file_node['Active'].should == 'true'
              end

              it "contains the file type" do
                @file_node.xpath('FileType').first.content.should == 'Photo'
              end

              it "contains the name" do
                @file_node.xpath('Name').first.content.should == '5A Kitchen'
              end

              it "contains the format" do
                @file_node.xpath('Format').first.content.should == 'image/jpeg'
              end

              it "contains the source" do
                @file_node.xpath('Src').first.content.should == 'http://images.com/unit-5A-kitchen.jpg'
              end

              it "contains the rank" do
                @file_node.xpath('Rank').first.content.should == '1'
              end

              it "contains the ad id" do
                @file_node.xpath('AdID').first.content.should == 'Ad ID'
              end

              it "contains the affiliate id" do
                @file_node.xpath('AffiliateID').first.content.should == 'Affiliate ID'
              end
            end
          end

          it "contains a promotion node for each overview bullet" do
            @property_node.xpath('Promotion').map(&:content).should =~ [
              'ovrvu bulet 1',
              'ovrvu bulet 2',
              'ovrvu bulet 3'
            ]
          end

          it "contains an amenity node for each property feature" do
            @property_node.xpath('Amenity').first.tap do |node|
              node['AmenityType'].should                     == 'RecRoom'
              node.xpath('Description').first.content.should == 'Such room'
              node.xpath('Rank').first.content.should        == '1'
            end

            @property_node.xpath('Amenity').last.tap do |node|
              node['AmenityType'].should                     == 'Garage'
              node['AmenitySubType'].should                  == 'Both'
              node.xpath('Description').first.content.should == 'Parking available both above and below ground.'
              node.xpath('Rank').first.content.should        == '2'
            end
          end

          context "within the property's file nodes" do
            before do
              @nodes = @property_node.xpath('File')
            end

            it "includes a node for each slide" do
              slide = @nodes.find { |node| node.xpath('Src').first.content.include? 'slide' }

              slide.xpath('FileType').first.content.should == 'Photo'
              slide.xpath('Name').first.content.should     == 'slide.jpg'
              slide.xpath('Format').first.content.should   == 'image/jpeg'
              slide.xpath('Src').first.content.should      == "http://bozzuto.com/system/property_slides/#{@slide.id}/slide.jpg"
              slide.xpath('Rank').first.content.should     == '1'
            end

            it "includes a node for its listing image" do
              image = @nodes.find { |node| node.xpath('Src').first.content.include? 'square' }

              image.xpath('FileType').first.content.should == 'Photo'
              image.xpath('Name').first.content.should     == 'square.jpg'
              image.xpath('Format').first.content.should   == 'image/jpeg'
              image.xpath('Src').first.content.should      == "http://bozzuto.com/system/apartment_communities/#{@community.id}/square.jpg"
              image.xpath('Rank').first.content.should     == '2'
            end

            it "includes a node for its video" do
              video = @nodes.find { |node| node.xpath('Src').first.content.include? 'videoapt' }

              video.xpath('FileType').first.content.should == 'Video'
              video.xpath('Name').first.content.should     == 'Default.aspx'
              video.xpath('Src').first.content.should      == 'http://www.videoapt.com/208/LibertyTowers/Default.aspx'
              video.xpath('Rank').first.content.should     == '3'
            end
          end

          it "renders multiple communities" do
            5.times { |n| ApartmentCommunity.make }

            xml = Bozzuto::Exports::Formats::Mits4_1.new.to_xml

            Nokogiri::XML(xml).xpath('//PhysicalProperty//Property').size.should == 6
          end
        end
      end
    end
  end
end
