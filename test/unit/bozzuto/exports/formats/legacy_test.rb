require 'test_helper'

module Bozzuto::Exports::Formats
  class LegacyTest < ActiveSupport::TestCase
    context "Bozzuto::Exports::Formats::Legacy" do
      describe ".for_communities" do
        it "instantiates and calls to_xml" do
          @legacy = mock('Bozzuto::Exports::Formats::Legacy')

          Bozzuto::Exports::Formats::Legacy.stubs(:new).returns(@legacy)

          @legacy.expects(:to_xml)

          Bozzuto::Exports::Formats::Legacy.to_xml
        end
      end

      describe ".to_s" do
        it "returns the format name" do
          Bozzuto::Exports::Formats::Legacy.to_s.should == 'Legacy'
        end
      end

      describe "#to_xml" do
        before do
          state  = State.make(:name => 'North Carolina', :code => 'NC')
          county = County.make(:name => 'Dawnguard', :state => state)
          city   = City.make(:name => 'Bogsville', :state => state, :counties => [county])

          twitter_account = TwitterAccount.new(:username => 'TheBozzutoGroup')
          twitter_account.save(:validate => false)

          @expiration_date = Time.current.advance(:days => 15)
          promo = Promo.make(:active,
            :title           => 'on sale meow',
            :subtitle        => 'come on down',
            :link_url        => 'http://buy.now',
            :expiration_date => @expiration_date
          )

          @overview_text = %q{
            <p>
              <em>dolan haev u seen pluto?</em>
              i jsut find him<br />
              yay where is he?
            </p>
          }

          @home = HomeCommunity.make

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
            :website_url             => 'http://what.up?dude=yo',
            :latitude                => 0.0,
            :longitude               => 45.0,
            :promo_id                => promo.id,
            :listing_image_file_name => 'test.jpg'
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

          PropertyFeaturesPage.make(
            :property => @community,
            :title_1  => 'Features',
            :text_1   => 'Here lies some features',
            :title_2  => nil,
            :text_2   => nil
          )

          PropertyFeature.make(:name => 'Feature Uno', :apartment_communities => [@community])
          PropertyFeature.make(:name => 'Feature Due', :apartment_communities => [@community])

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
            :max_rent            => 2300
          )

          @community.reload
          @community.save

          @nearby_community = ApartmentCommunity.make(:with_core_id,
            :title     => 'I R Close',
            :latitude  => -30.0,
            :longitude => -100.0,
            :city      => city
          )

          @excluded = ApartmentCommunity.make(:excluded_from_export, :with_core_id, :city => city)

          PropertyNeighborhoodPage.make({
            :property => @community,
            :content  => 'wilcum to da hood'
          })

          @xml = Nokogiri::XML(Bozzuto::Exports::Formats::Legacy.new.to_xml)
        end

        it "contains PhysicalProperty node" do
          @xml.xpath("//PhysicalProperty").present?.should == true
        end

        it "contains Property node" do
          @xml.xpath("//PhysicalProperty/Property").present?.should == true
        end

        context "within PropertyID node" do
          before do
            @property_id_node = @xml.xpath('//PhysicalProperty//Property//PropertyID').first
          end

          context "within Identification node" do
            before do
              @identification_node = @property_id_node.xpath('Identification').first
            end

            it "contains property id" do
              @identification_node.xpath('PrimaryID').first.content.to_i.should == 999
            end

            it "contains property title" do
              @identification_node.xpath('MarketingName').first.content.should == @community.title
            end

            it "contains property website" do
              @identification_node.xpath('WebSite').first.content.should == 'http://what.up'
            end

            it "contains bozzuto url" do
              expected_url = "http://bozzuto.com/apartments/communities/#{@community.to_param}"

              @identification_node.xpath('BozzutoURL').first.content.should == expected_url
            end

            it "contains latitude" do
              @identification_node.xpath('Latitude').first.content.should == @community.latitude.to_s
            end

            it "contains longitude" do
              @identification_node.xpath('Longitude').first.content.should == @community.longitude.to_s
            end
          end

          context "within Address node" do
            before do
              @address_node = @property_id_node.xpath('Address').first
            end

            it "contains property street address" do
              @address_node.xpath('Address1').first.content.should == @community.street_address
            end

            it "contains property city" do
              @address_node.xpath('City').first.content.should == @community.city.name
            end

            it "contains property state" do
              @address_node.xpath('State').first.content.should == @community.state.code
            end

            it "contains property postal code" do
              @address_node.xpath('PostalCode').first.content.should == @community.zip_code
            end

            it "contains property county name" do
              @address_node.xpath('CountyName').first.content.should == @community.county.name
            end

            it "contains property email" do
              @address_node.xpath('Lead2LeaseEmail').first.content.should == @community.lead_2_lease_email
            end
          end

          it "contains property phone number" do
            @property_id_node.xpath('Phone[@Type="office"]//PhoneNumber').first.content.should == @community.phone_number
          end
        end

        context "with features" do
          before do
            @feature_node = @xml.xpath('//PhysicalProperty//Property//Feature').first
          end

          it "contains feature title" do
            @feature_node.xpath('Title').first.content.should == 'Features'
          end

          it "contains feature text" do
            @feature_node.xpath('Description').first.content.should == 'Here lies some features'
          end
        end

        context "with feature buttons" do
          before do
            @featured_button_node = @xml.xpath('//PhysicalProperty//Property//FeaturedButton').first
          end

          it "contains name" do
            @featured_button_node.xpath('Name').first.content.should == 'Feature Uno'
          end
        end

        context "within Information node" do
          before do
            @information_node = @xml.xpath('//PhysicalProperty//Property//Information').first
          end

          context "with office hours" do
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

          it "contains overview text" do
            @information_node.xpath('OverviewText').first.content.should == @overview_text
          end

          it "contains overview text stripped" do
            @information_node.xpath('OverviewTextStripped').first.content.should == 'dolan haev u seen pluto? i jsut find him yay where is he?'
          end

          it "contains overview bullet 1" do
            @information_node.xpath("OverviewBullet1").first.content.should == 'ovrvu bulet 1'
          end

          it "contains overview bullet 2" do
            @information_node.xpath("OverviewBullet2").first.content.should == 'ovrvu bulet 2'
          end

          it "contains overview bullet 3" do
            @information_node.xpath("OverviewBullet3").first.content.should == 'ovrvu bulet 3'
          end

          it "contains neighborhood text" do
            @information_node.xpath('NeighborhoodText').first.content.should == 'wilcum to da hood'
          end

          it "contains directions link" do
            @information_node.xpath('DirectionsURL').first.content.should == 'http://maps.google.com/maps?daddr=100%20Gooby%20Pls,%20Bogsville,%20NC'
          end

          it "contains property listing image" do
            @information_node.xpath('ListingImageURL').first.content.should =~ %r{http://bozzuto\.com/system/apartment_communities/\d+/square\.jpg}
          end

          it "contains video url" do
            @information_node.xpath('VideoURL').first.content.should == 'http://www.videoapt.com/208/LibertyTowers/Default.aspx'
          end

          it "contains facebook url" do
            @information_node.xpath('FacebookURL').first.content.should == 'http://facebook.com/dafuq'
          end

          it "contains twitter handle" do
            @information_node.xpath('TwitterHandle').first.content.should == 'TheBozzutoGroup'
          end

          it "contains pinterest url" do
            @information_node.xpath('PinterestURL').first.content.should == 'http://pinterest.com/bozzuto'
          end
        end

        context "with nearby apartment communities" do
          before do
            @nearby_node = @xml.xpath('//PhysicalProperty//Property//NearbyCommunity').first
          end

          it "contains id" do
            @nearby_node['Id'].should == @nearby_community.id.to_s
          end

          it "contains title" do
            @nearby_node.xpath('Name').first.content.should == @nearby_community.title
          end
        end

        context "with slideshow" do
          before do
            @slideshow_node = @xml.xpath('//PhysicalProperty//Property//Slideshow').first
          end

          it "contains an image URL" do
            @slideshow_node.xpath('SlideshowImageURL').first.content.should == "http://bozzuto.com#{@slide.image.url(:slide)}"
          end
        end

        context "with floor plans" do
          before do
            @floor_plan_node = @xml.xpath("//PhysicalProperty//Property//Floorplan[@Id=\"#{@floor_plan.id}\"]").first
          end

          it "contains name" do
            @floor_plan_node.xpath('Name').first.content.should == 'The Roxy'
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

          it "contains minimum square footage" do
            @floor_plan_node.xpath('SquareFeet').first['Min'].should == '1400'
          end

          it "contains maximum square footage" do
            @floor_plan_node.xpath('SquareFeet').first['Max'].should == '1400'
          end

          it "contains availability url" do
            @floor_plan_node.xpath('FloorplanAvailabilityURL').first.content.should == 'http://lol.wut'
          end

          it "contains available units" do
            @floor_plan_node.xpath('DisplayedUnitsAvailable').first.content.should == '3'
          end

          it "contains image url" do
            @floor_plan_node.xpath('ImageURL').first.content.should =~ %r{http://bozzuto\.com/system/apartment_floor_plans/\d+/original\.jpg}
          end

          it "contains number of bedrooms" do
            @floor_plan_node.xpath('Bedrooms').first.content.should == '3'
          end

          it "contains number of bathrooms" do
            @floor_plan_node.xpath('Bathrooms').first.content.should == '2.0'
          end
        end

        context "with promotion" do
          before do
            @promotion_node = @xml.xpath('//PhysicalProperty//Property//Promotion').first
          end

          it "contains title" do
            @promotion_node.xpath('Title').first.content.should == 'on sale meow'
          end

          it "contains subtitle" do
            @promotion_node.xpath('Subtitle').first.content.should == 'come on down'
          end

          it "contains link url" do
            @promotion_node.xpath('LinkURL').first.content.should == 'http://buy.now'
          end

          context "with expiration date" do
            before do
              @expiration_date_node = @promotion_node.xpath('ExpirationDate').first
            end

            it "contains month" do
              @expiration_date_node['Month'].should == @expiration_date.strftime('%m')
            end

            it "contains day" do
              @expiration_date_node['Day'].should == @expiration_date.strftime('%d')
            end

            it "contains year" do
              @expiration_date_node['Year'].should == @expiration_date.strftime('%Y')
            end
          end
        end

        it "renders multiple communities" do
          2.times { |n| ApartmentCommunity.make(:with_core_id) }

          xml = Bozzuto::Exports::Formats::Legacy.new.to_xml

          Nokogiri::XML(xml).xpath('//PhysicalProperty//Property').size.should == 5
        end
      end
    end
  end
end
