require 'test_helper'

module Bozzuto::Exports
  class DataTest < ActiveSupport::TestCase
    context "Bozzuto::Exports::DataTest" do
      describe ".for_communities" do
        it "instantiates and grabs the communities data" do
          @data = mock('Bozzuto::Exports::Data')

          Bozzuto::Exports::Data.stubs(:new).returns(@data)

          @data.expects(:communities)

          Bozzuto::Exports::Data.for_communities
        end
      end

      describe "#communities" do
        before do
          state  = State.make(:name => 'North Carolina', :code => 'NC')
          county = County.make(:name => 'Dawnguard', :state => state)
          city   = City.make(:name => 'Bogsville', :state => state, :counties => [county])

          twitter_account = TwitterAccount.new(:username => 'TheBozzutoGroup')
          twitter_account.save(:validate => false)

          local_info_feed = Feed.make_unsaved(:url => 'http://bozzuto.com/feed')
          local_info_feed.expects(:feed_valid?)
          local_info_feed.save

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
            :local_info_feed         => local_info_feed,
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

          @features_page = PropertyFeaturesPage.make(
            :property => @community,
            :title_1  => 'One Face',
            :text_1   => 'has one face',
            :title_2  => 'Two Face',
            :text_2   => 'has two faces',
            :title_3  => 'Red Face',
            :text_3   => 'has red face'
          )

          PropertyFeature.make(:name => 'Feature Uno', :properties => [@community])
          PropertyFeature.make(:name => 'Feature Due', :properties => [@community])

          @slideshow = PropertySlideshow.make(:property => @community)
          @slide     = PropertySlide.make(:property_slideshow => @slideshow)

          # FIXME: must save twice to update the cached_slug to include the id
          @community.reload
          @community.save

          @nearby_community = ApartmentCommunity.make(
            :title     => 'I R Close',
            :latitude  => -30.0,
            :longitude => -100.0,
            :city      => city
          )

          @excluded = ApartmentCommunity.make(:excluded_from_export, :city => city)

          PropertyNeighborhoodPage.make({
            :property => @community,
            :content  => 'wilcum to da hood'
          })

          @communities    = Bozzuto::Exports::Data.new.communities
          @test_community = @communities.first
        end

        it "only includes properties flagged for inclusion in the report" do
          @communities.any? { |community| community.title == @excluded.title }
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

        it "contains the full address" do
          @test_community.full_address.should == '100 Gooby Pls, Bogsville, NC 89223'
        end

        it "contains Lead2Lease email address" do
          @test_community.lead_2_lease_email.should == 'dolan@pls.org'
        end

        it "contains phone number" do
          @test_community.phone_number.should == '832.382.1337'
        end

        it "contains the appropriate features" do
          @test_community.features[0].title.should == 'One Face'
          @test_community.features[0].text.should == 'has one face'
          @test_community.features[1].title.should == 'Two Face'
          @test_community.features[1].text.should == 'has two faces'
          @test_community.features[2].title.should == 'Red Face'
          @test_community.features[2].text.should == 'has red face'
        end

        it "contains the appropriate slides" do
          @test_community.slides.first.image_url.should =~ %r{http://bozzuto\.com/system/property_slides/#{@slide.id}/slide\.jpg}
        end

        it "contains the listing image" do
          @test_community.listing_image.should =~ %r{http://bozzuto\.com/system/apartment_communities/\d+/square\.jpg}
        end

        it "contains video link" do
          @test_community.video_url.should == 'http://www.videoapt.com/208/LibertyTowers/Default.aspx'
        end

        it "contains neighborhood text" do
          @test_community.neighborhood_text.should == 'wilcum to da hood'
        end

        it "contains office hours" do
          @test_community.office_hours.should =~ @office_hours
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

        it "contains the appropriate features" do
          @test_community.property_features.first.name.should == 'Feature Uno'
          @test_community.property_features.last.name.should  == 'Feature Due'
        end

        it "contains a directions url" do
          @test_community.directions_url.should == 'http://maps.google.com/maps?daddr=100%20Gooby%20Pls,%20Bogsville,%20NC'
        end

        it "contains local info RSS feed" do
          @test_community.local_info_feed.should == 'http://bozzuto.com/feed'
        end

        it "contains the website url" do
          @test_community.website_url.should == 'http://what.up'
        end

        it "contains the community URL on Bozzuto.com" do
          @test_community.bozzuto_url.should == "http://bozzuto.com/apartments/communities/#{@community.id}-dolans-hood"
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
        end

        context "when the community has no features page" do
          before do
            @test_community.stubs(:features_page).returns(nil)
          end

          it "returns an empty array" do
            @test_community.features.should == []
          end
        end

        context "when the community has a features page without title or text" do
          before do
            @features_page.update_attributes(
              :title_1  => nil,
              :text_1   => nil,
              :title_2  => nil,
              :text_2   => nil,
              :title_3  => nil,
              :text_3   => nil
            )

            @test_community = Bozzuto::Exports::Data.new.communities.first
          end

          it "returns an empty array" do
            @test_community.features.should == []
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
            @test_plan.image_url.should =~ %r{http://bozzuto\.com/system/apartment_floor_plans/\d+/original\.jpg}
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
          5.times do |n|
            ApartmentCommunity.make
          end

          Bozzuto::Exports::Data.new.communities.size.should == 7
        end
      end
    end
  end
end
