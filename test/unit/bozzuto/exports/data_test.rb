require 'test_helper'

module Bozzuto::Exports
  class DataTest < ActiveSupport::TestCase
    context "Bozzuto::Exports::DataTest" do
      describe ".communities" do
        it "instantiates and grabs the communities data" do
          @data = mock('Bozzuto::Exports::Data')

          Bozzuto::Exports::Data.stubs(:new).returns(@data)

          @data.expects(:communities)

          Bozzuto::Exports::Data.communities
        end
      end

      describe ".combined_communities" do
        it "instantiates and grabs the communities data" do
          @data = mock('Bozzuto::Exports::Data')

          Bozzuto::Exports::Data.stubs(:new).returns(@data)

          @data.expects(:combined_communities)

          Bozzuto::Exports::Data.combined_communities
        end
      end

      describe "#communities and #combined_communities" do
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
            :title_1  => 'One Face',
            :text_1   => 'has one face',
            :title_2  => 'Two Face',
            :text_2   => 'has two faces',
            :title_3  => 'Red Face',
            :text_3   => 'has red face'
          )

          PropertyFeature.make(:name => 'Feature Uno', :apartment_communities => [@community])
          PropertyFeature.make(:name => 'Feature Due', :apartment_communities => [@community])

          @slideshow = PropertySlideshow.make(:property => @community)
          @slide     = PropertySlide.make(:property_slideshow => @slideshow)

          # FIXME: must save twice to update the cached_slug to include the id
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

          @home_community      = HomeCommunity.make(title: 'Boomtown Estates', listing_image_file_name: 'test.jpg')
          @communities         = Bozzuto::Exports::Data.new.combined_communities
          @test_community      = @communities.first
          @test_home_community = @communities.last
        end

        it "only includes properties flagged for inclusion in the report" do
          @communities.any? { |community| community.title == @excluded.title }
        end

        it "contains the appropriate ID" do
          @test_community.id.should == 999
          @test_home_community.id.should == @home_community.id
        end

        it "contains community title" do
          @test_community.title.should == 'Dolans Hood'
        end

        it "contains street address" do
          @test_community.street_address.should == '100 Gooby Pls'
        end

        it "contains city" do
          @test_community.city.should == 'Bogsville'
        end

        it "contains state" do
          @test_community.state.should == 'NC'
        end

        it "contains zip code" do
          @test_community.zip_code.should == '89223'
        end

        it "contains county" do
          @test_community.county.should == 'Dawnguard'
        end

        it "contains zip" do
          @test_community.zip.should == '89223'
        end

        it "contains address line 1" do
          @test_community.address_line_1.should == '100 Gooby Pls'
        end

        it "contains Lead2Lease email address" do
          @test_community.lead_2_lease_email.should == 'dolan@pls.org'
        end

        it "contains phone number" do
          @test_community.phone_number.should == '832.382.1337'
        end

        it "contains the appropriate slides" do
          @test_community.slides.first.image_url.should match(%r{http://bozzuto\.com/system/property_slides/#{@slide.id}/slide\.jpg})
        end

        it "contains the appropriate features" do
          @test_community.features[0].title.should == 'One Face'
          @test_community.features[0].text.should  == 'has one face'
          @test_community.features[1].title.should == 'Two Face'
          @test_community.features[1].text.should  == 'has two faces'
          @test_community.features[2].title.should == 'Red Face'
          @test_community.features[2].text.should  == 'has red face'
        end

        it "contains the listing image" do
          @test_community.listing_image.should match(%r{http://bozzuto\.com/system/apartment_communities/\d+/square\.jpg})
          @test_home_community.listing_image.should match(%r{http://bozzuto\.com/system/home_communities/\d+/square\.jpg})
        end

        it "contains video link" do
          @test_community.video_url.should == 'http://www.videoapt.com/208/LibertyTowers/Default.aspx'
        end

        it "contains neighborhood text" do
          @test_community.neighborhood_text.should == 'wilcum to da hood'
        end

        it "contains office hours" do
          @test_community.office_hours.should match_array(@office_hours)
        end

        it "contains overview text" do
          @test_community.overview_text.should == @overview_text
        end

        it "contains overview bullet 1" do
          @test_community.overview_bullet_1.should == 'ovrvu bulet 1'
        end

        it "contains overview bullet 2" do
          @test_community.overview_bullet_2.should == 'ovrvu bulet 2'
        end

        it "contains overview bullet 3" do
          @test_community.overview_bullet_3.should == 'ovrvu bulet 3'
        end

        it "contains facebook_url" do
          @test_community.facebook_url.should == 'http://facebook.com/dafuq'
        end

        it "contains twitter handle" do
          @test_community.twitter_handle.should == 'TheBozzutoGroup'
        end

        it "contains #pinterest_url" do
          @test_community.pinterest_url.should == 'http://pinterest.com/bozzuto'
        end

        it "contains the appropriate promo data" do
          @promo = @test_community.promo

          @promo.title.should                == 'on sale meow'
          @promo.subtitle.should             == 'come on down'
          @promo.link_url.should             == 'http://buy.now'
          @promo.expiration_date.to_s.should == @expiration_date.to_s
        end

        it "contains the appropriate property features" do
          @test_community.property_features.first.name.should == 'Feature Uno'
          @test_community.property_features.last.name.should  == 'Feature Due'
        end

        it "contains a directions url" do
          @test_community.directions_url.should == 'http://maps.google.com/maps?daddr=100%20Gooby%20Pls,%20Bogsville,%20NC'
        end

        it "contains the website url" do
          @test_community.website_url.should == 'http://what.up'
        end

        it "contains the community URL on Bozzuto.com" do
          @test_community.bozzuto_url.should == "http://bozzuto.com/apartments/communities/#{@community.to_param}"
          @test_home_community.bozzuto_url.should == "http://bozzuto.com/new-homes/communities/#{@home_community.to_param}"
        end

        it "contains latitude" do
          @test_community.latitude.should == 0.0
        end

        it "contains longitude" do
          @test_community.longitude.should == 45.0
        end

        it "contains the nearby communities" do
          @test_community.nearby_communities.first.id.should    == @nearby_community.id
          @test_community.nearby_communities.first.title.should == @nearby_community.title
          @test_home_community.nearby_communities.should == []
        end

        it "contains no floor plan records" do
          @test_community.floor_plans.should == []
          @test_home_community.floor_plans.should == []
        end

        context "when the community does not have a website URL" do
          before do
            @test_community.update_attributes(:website_url => nil)
          end

          it "falls back to the Bozzuto URL" do
            @test_community.bozzuto_url.should == "http://bozzuto.com/apartments/communities/#{@community.to_param}"
          end
        end

        context "with expired promo" do
          before do
            promo = Promo.make(:expired)
            @community.update_attributes(:promo_id => promo.id)

            @test_community = Bozzuto::Exports::Data.new.communities.first
          end

          it "returns nil" do
            @test_community.promo.should == nil
          end
        end

        context "with floor plans" do
          before do
            @floor_plan = ApartmentFloorPlan.make(
              :apartment_community => @community,
              :name                => 'The Roxy',
              :availability_url    => 'http://lol.wut',
              :available_units     => 3,
              :image_file_name     => 'test.jpg',
              :image_type          => ApartmentFloorPlan::USE_IMAGE_FILE,
              :bedrooms            => 2,
              :bathrooms           => 1,
              :min_square_feet     => 1400,
              :max_square_feet     => 1400,
              :min_rent            => 2260,
              :max_rent            => 2300
            )

            @communities = Bozzuto::Exports::Data.new.communities
            @test_plan   = @communities.first.floor_plans.first
          end

          it "contains id" do
            @test_plan.id.should == @floor_plan.id
          end

          it "contains name" do
            @test_plan.name.should == 'The Roxy'
          end

          it "contains availability url" do
            @test_plan.availability_url.should == 'http://lol.wut'
          end

          it "contains available units" do
            @test_plan.available_units.should == 3
          end

          it "contains image url" do
            @test_plan.image_url.should match(%r{http://bozzuto\.com/system/apartment_floor_plans/\d+/original\.jpg})
          end

          it "contains number of bedrooms" do
            @test_plan.bedrooms.should == 2
          end

          it "contains number of bathrooms" do
            @test_plan.bathrooms.should == 1
          end

          it "contains min square feet" do
            @test_plan.min_square_feet.should == 1400
          end

          it "contains max square feet" do
            @test_plan.max_square_feet.should == 1400
          end

          it "contains min rent" do
            @test_plan.min_rent.should == 2260
          end

          it "contains max rent" do
            @test_plan.max_rent.should == 2300
          end

          context "with units" do
            before do
              @unit1 = ApartmentUnit.make(
                :floor_plan      => @floor_plan,
                :external_cms_id => '123',
                :marketing_name  => 'Penthouse 1A',
                :unit_rent       => nil,
                :market_rent     => 2000,
                :address_line_2  => 'Unit P1A'
              )

              @unit2 = ApartmentUnit.make(
                :floor_plan               => @floor_plan,
                :external_cms_type        => 'rent_cafe',
                :external_cms_id          => '5C',
                :building_external_cms_id => '456',
                :marketing_name           => nil,
                :unit_rent                => nil,
                :market_rent              => nil,
                :max_rent                 => 2525.50
              )

              @floor_plan.apartment_units << @unit1
              @floor_plan.apartment_units << @unit2

              @communities      = Bozzuto::Exports::Data.new.communities
              @test_plan        = @communities.first.floor_plans.first
              @normal_unit      = @test_plan.units.first
              @exceptional_unit = @test_plan.units.last
            end

            it "contains the correct names" do
              @normal_unit.name.should == 'Penthouse 1A'
              @exceptional_unit.name.should == '5C'
            end

            it "contains the correct sync IDs" do
              @normal_unit.sync_id.should == '123'
              @exceptional_unit.sync_id.should == '456'
            end

            it "contains the correct unit rent values" do
              @normal_unit.unit_rent.should == 2000.0
              @exceptional_unit.unit_rent.should == 2525.50
            end

            it "contains the correct market rent values" do
              @normal_unit.market_rent.should == 2000.0
              @exceptional_unit.market_rent.should == 2525.50
            end

            it "contains the correct address data" do
              @normal_unit.address_line_1.should == '100 Gooby Pls'
              @normal_unit.address_line_2.should == 'Unit P1A'
              @normal_unit.city.should           == 'Bogsville'
              @normal_unit.state.should          == 'NC'
              @normal_unit.zip.should            == '89223'
            end
          end
        end

        context "having floor plans with 0 available units" do
          before do
            @floor_plan = ApartmentFloorPlan.make(
              :apartment_community => @community,
              :name                => 'The Roxy',
              :availability_url    => 'http://lol.wut',
              :available_units     => 0,
              :image_file_name     => 'test.jpg',
              :image_type          => ApartmentFloorPlan::USE_IMAGE_FILE,
              :bedrooms            => 2,
              :bathrooms           => 1,
              :min_square_feet     => 1400,
              :max_square_feet     => 1400,
              :min_rent            => 2260,
              :max_rent            => 2300
            )

            @communities = Bozzuto::Exports::Data.new.communities
            @test_plan   = @communities.first.floor_plans.first
          end

          it "sets the min rent to 0" do
            @test_plan.min_rent.should == 0
          end

          it "sets the max rent to 0" do
            @test_plan.max_rent.should == 0
          end
        end

        it "handles multiple communities" do
          2.times { ApartmentCommunity.make(:with_core_id) }
          2.times { HomeCommunity.make }

          Bozzuto::Exports::Data.new.communities.size.should == 4
          Bozzuto::Exports::Data.new.combined_communities.size.should == 7
        end
      end
    end
  end
end
