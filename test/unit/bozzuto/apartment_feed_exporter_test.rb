require 'test_helper'

module Bozzuto
  class ApartmentFeedExporterTest < ActiveSupport::TestCase
    context "pulling data" do
      setup do
        @office_hours = [
          {
            :open_time  => '9:00 AM',
            :close_time => '6:00 PM',
            :day        => 'Monday'
          }, {
            :open_time  => '9:00 AM',
            :close_time => '12:00 PM',
            :day        => 'Saturday'
          }
        ]

        state = State.make({
          :name => 'North Carolina',
          :code => 'NC'
        })

        county = County.make({
          :name  => 'Dawnguard',
          :state => state
        })

        city = City.make({
          :name     => 'Bogsville',
          :state    => state,
          :counties => [county]
        })

        twitter_account = TwitterAccount.new(:username => 'TheBozzutoGroup')
        twitter_account.save(:validate => false)

        local_info_feed = Feed.make_unsaved({
          :url => 'http://bozzuto.com/feed'
        })
        local_info_feed.expects(:feed_valid?)
        local_info_feed.save

        @expiration_date = Time.current.advance(:days => 15)
        promo = Promo.make(:active, {
          :title           => 'on sale meow',
          :subtitle        => 'come on down',
          :link_url        => 'http://buy.now',
          :expiration_date => @expiration_date
        })

        @overview_text = %q{
          <p>
            <em>dolan haev u seen pluto?</em>
            i jsut find him<br />
            yay where is he?
          </p>
        }

        @community = ApartmentCommunity.make({
          :title                   => 'Dolans Hood',
          :street_address          => '100 Gooby Pls',
          :city                    => city,
          :zip_code                => '89223',
          :county                  => county,
          :lead_2_lease_email      => 'dolan@pls.org',
          :phone_number            => '832.382.1337',
          :video_url               => 'http://www.videoapt.com/208/LibertyTowers/Default.aspx',
          :office_hours            => @office_hours,
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
        })

        # FIXME: must save twice to update the cached_slug to include the id
        @community.reload
        @community.save

        ApartmentCommunity.make(
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

        @exporter     = ApartmentFeedExporter.new
        @first_export = @exporter.data[:properties].first
      end

      should "only include properties flagged for inclusion in the export" do
        assert @exporter.data[:properties].none? { |p| p[:community_name] == @excluded.title }
      end

      should "contain Community Name" do
        assert_equal 'Dolans Hood', @first_export[:community_name]
      end

      should "contain Community Address 1" do
        assert_equal '100 Gooby Pls', @first_export[:community_address_1]
      end

      should "contain City" do
        assert_equal 'Bogsville', @first_export[:city]
      end

      should "contain State" do
        assert_equal 'NC', @first_export[:state]
      end

      should "contain Postal Code" do
        assert_equal '89223', @first_export[:postal_code]
      end

      should "contain County" do
        assert_equal 'Dawnguard', @first_export[:county]
      end

      should "contain Lead2Lease Email Address" do
        assert_equal 'dolan@pls.org', @first_export[:lead_2_lease_email]
      end

      should "contain Phone Number" do
        assert_equal '832.382.1337', @first_export[:phone_number]
      end

      context "Features and Amenities" do
        setup do
          @features_page = PropertyFeaturesPage.make({
            :property => @community,
            :title_1  => nil,
            :text_1   => nil,
            :title_2  => nil,
            :text_2   => nil
          })
        end

        context "with no title or text" do
          setup do
            @first_export = @exporter.data[:properties].first
          end

          should "return empty array for Features" do
            assert_equal [], @first_export[:features]
          end
        end

        context "with 1 title and text" do
          setup do
            @features_page.update_attributes({
              :title_1  => 'Gooby pls',
              :text_1   => 'u r tru frend',
            })

            @first_export = @exporter.data[:properties].first
          end

          should "return array with one object" do
            assert_equal 1, @first_export[:features].length
          end

          should "return correct title and text" do
            expected = [{ :title => 'Gooby pls', :text => 'u r tru frend' }]

            assert_same_elements @first_export[:features], expected
          end
        end

        context "with 2 title and text" do
          setup do
            @features_page.update_attributes({
              :title_1  => 'One Face',
              :text_1   => 'has one face',
              :title_2  => 'Two Face',
              :text_2   => 'has two faces'
            })

            @first_export = @exporter.data[:properties].first
          end

          should "return array with two objects" do
            assert_equal 2, @first_export[:features].length
          end

          should "return correct features" do
            expected = [
              { :title => 'One Face', :text => 'has one face' },
              { :title => 'Two Face', :text => 'has two faces' }
            ]

            assert_same_elements @first_export[:features], expected
          end
        end

        context "with 3 title and text" do
          setup do
            @features_page.update_attributes({
              :title_1  => 'One Face',
              :text_1   => 'has one face',
              :title_2  => 'Two Face',
              :text_2   => 'has two faces',
              :title_3  => 'Red Face',
              :text_3   => 'has red face'
            })

            @first_export = @exporter.data[:properties].first
          end

          should "return array with three objects" do
            assert_equal 3, @first_export[:features].length
          end

          should "return correct features" do
            expected = [
              { :title => 'One Face', :text => 'has one face' },
              { :title => 'Two Face', :text => 'has two faces' },
              { :title => 'Red Face', :text => 'has red face' }
            ]

            assert_same_elements @first_export[:features], expected
          end
        end
      end

      context "with Slideshow" do
        setup do
          slideshow = PropertySlideshow.make(:property => @community)
          @slide = PropertySlide.make(:property_slideshow => slideshow)

          @first_export = @exporter.data[:properties].first
        end

        should "contain an entry for the slide" do
          assert_equal @slide.image.url(:slide),
            @first_export[:slideshow_slides].first[:image_url]
        end
      end

      should "contain listing image" do
        assert_match %r{http://bozzuto\.com/system/apartment_communities/\d+/square\.jpg},
          @first_export[:listing_image]
      end

      should "contain Video Link" do
        assert_equal 'http://www.videoapt.com/208/LibertyTowers/Default.aspx',
          @first_export[:video_url]
      end

      should "contain Neighborhood Text" do
        assert_equal 'wilcum to da hood', @first_export[:neighborhood_text]
      end

      should "contain Office Hours" do
        assert_same_elements @first_export[:office_hours], @office_hours
      end

      should "contain Overview Text" do
        assert_equal @overview_text, @first_export[:overview_text]
      end

      context "contain Three Bullets" do
        1.upto(3) do |n|
          should "contain overview_bullet_#{n}" do
            assert_equal "ovrvu bulet #{n}",
              @first_export["overview_bullet_#{n}".to_sym]
          end
        end
      end

      context "with floor plans" do
        setup do
          @floor_plan = ApartmentFloorPlan.make({
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
          })

          @first_export = @exporter.data[:properties].first
          @floor_plan_data = @first_export[:floorplans].first
        end

        should "contain #id" do
          assert_equal @floor_plan.id, @floor_plan_data[:id]
        end

        should "contain #name" do
          assert_equal 'The Roxy', @floor_plan_data[:name]
        end

        should "contain #availability_url" do
          assert_equal 'http://lol.wut', @floor_plan_data[:availability_url]
        end

        should "contain #available_units" do
          assert_equal 3, @floor_plan_data[:available_units]
        end

        should "contain #image url" do
          assert_match %r{http://bozzuto\.com/system/apartment_floor_plans/\d+/original\.jpg},
            @floor_plan_data[:image_url]
        end

        should "contain number of bedrooms" do
          assert_equal 2, @floor_plan_data[:bedrooms]
        end

        should "contain number of bathrooms" do
          assert_equal 1, @floor_plan_data[:bathrooms]
        end

        should "contain #min_square_feet" do
          assert_equal 1400, @floor_plan_data[:min_square_feet]
        end

        should "contain #max_square_feet" do
          assert_equal 1400, @floor_plan_data[:max_square_feet]
        end

        should "contain #min_rent" do
          assert_equal 2260, @floor_plan_data[:min_rent]
        end

        should "contain #max_rent" do
          assert_equal 2300, @floor_plan_data[:max_rent]
        end
      end

      should "contain #facebook_url" do
        assert_equal 'http://facebook.com/dafuq', @first_export[:facebook_url]
      end

      should "contain twitter_accounts#username" do
        assert_equal 'TheBozzutoGroup', @first_export[:twitter_handle]
      end

      should "contain #pinterest_url" do
        assert_equal 'http://pinterest.com/bozzuto',
          @first_export[:pinterest_url]
      end

      context "with active promo" do
        setup do
          @first_export = @exporter.data[:properties].first
          @promo_data = @first_export[:promo]
        end

        should "contain promo#title" do
          assert_equal 'on sale meow', @promo_data[:title]
        end

        should "contain promo#subtitle" do
          assert_equal 'come on down', @promo_data[:subtitle]
        end

        should "contain promo#link_url" do
          assert_equal 'http://buy.now', @promo_data[:link_url]
        end

        should "contain promo#expiration_date" do
          assert_equal @expiration_date.to_s(:month_day_year),
            @promo_data[:expiration_date].to_s(:month_day_year)
        end
      end

      context "with expired promo" do
        setup do
          promo = Promo.make(:expired)
          @community.update_attributes(:promo_id => promo.id)

          @first_export = @exporter.data[:properties].first
        end

        should "return empty hash" do
          assert @first_export[:promo].empty?
        end
      end

      context "with property features" do
        setup do
          feature1 = PropertyFeature.make({
            :name => 'Feature Uno'
          })

          feature2 = PropertyFeature.make({
            :name => 'Feature Due'
          })

          feature1.properties << @community
          feature2.properties << @community

          @first_export = @exporter.data[:properties].first
        end

        should "contain feature 1 name" do
          actual = @first_export[:featured_buttons][0]

          assert_equal 'Feature Uno', actual[:name]
        end

        should "contain feature 2 name" do
          actual = @first_export[:featured_buttons][1]

          assert_equal 'Feature Due', actual[:name]
        end
      end

      should "contain Directions Link" do
        expected = 'http://maps.google.com/maps?daddr=100%20Gooby%20Pls,%20Bogsville,%20NC'
        assert_equal expected, @first_export[:directions_url]
      end

      should "contain Local Info RSS Feed" do
        assert_equal 'http://bozzuto.com/feed',
          @first_export[:local_info_feed]
      end

      context "with Nearby Apartment Communities" do
        setup do
          @nearby_community = @first_export[:nearby_communities].first
        end

        should "contain id" do
          assert_not_nil @nearby_community[:id]
        end

        should "contain title" do
          assert_equal 'I R Close', @nearby_community[:title]
        end
      end

      should "contain #website_url" do
        assert_equal 'http://what.up', @first_export[:website_url]
      end

      should "contain Bozzuto.com Address" do
        assert_equal "http://bozzuto.com/apartments/communities/#{@community.id}-dolans-hood", @first_export[:bozzuto_url]
      end

      should "contain latitude" do
        assert_equal 0.0, @first_export[:latitude]
      end

      should "contain longitude" do
        assert_equal 45.0, @first_export[:longitude]
      end

      should "handle multiple communities" do
        5.times do |n|
          ApartmentCommunity.make
        end

        assert_equal 7, @exporter.data[:properties].size
      end

      context "formatting XML" do
        setup do
          PropertyFeaturesPage.make({
            :property => @community,
            :title_1  => 'Features',
            :text_1   => 'Here lies some features',
            :title_2  => nil,
            :text_2   => nil
          })

          slideshow = PropertySlideshow.make(:property => @community)
          @slide = PropertySlide.make(:property_slideshow => slideshow)

          @floor_plan = ApartmentFloorPlan.make({
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
          })

          PropertyFeature.make({
            :name       => 'Feature Uno',
            :properties => [@community]
          })

          PropertyFeature.make({
            :name       => 'Feature Due',
            :properties => [@community]
          })

          @doc = Nokogiri::XML(@exporter.to_xml)
        end

        should "contain PhysicalProperty node" do
          assert @doc.xpath("//PhysicalProperty").present?
        end

        should "contain Property node" do
          assert @doc.xpath("//PhysicalProperty/Property").present?
        end

        context "within PropertyID node" do
          setup do
            path = '//PhysicalProperty//Property//PropertyID'
            @property_id_node = @doc.xpath(path)[0]
          end

          context "within Identification node" do
            setup do
              @identification_node = @property_id_node.xpath('Identification')[0]
            end

            should "contain property id" do
              actual = @identification_node.xpath('PrimaryID')[0].content.to_i
              assert_equal @community.id, actual
            end

            should "contain property title" do
              actual = @identification_node.xpath('MarketingName')[0].content
              assert_equal @community.title, actual
            end

            should "contain property website" do
              actual = @identification_node.xpath('WebSite')[0].content
              assert_equal @community.website_url, actual
            end

            should "contain bozzuto url" do
              assert_equal "http://bozzuto.com/apartments/communities/#{@community.id}-dolans-hood",
                @identification_node.xpath('BozzutoURL')[0].content
            end

            should "contain latitude" do
              assert_equal '0.0',
                @identification_node.xpath('Latitude')[0].content
            end

            should "contain longitude" do
              assert_equal '45.0',
                @identification_node.xpath('Longitude')[0].content
            end
          end

          context "within Address node" do
            setup do
              @address_node = @property_id_node.xpath('Address')[0]
            end

            should "contain property street address" do
              actual = @address_node.xpath('Address1')[0].content
              assert_equal @community.street_address, actual
            end

            should "contain property city" do
              actual = @address_node.xpath('City')[0].content
              assert_equal @community.city.name, actual
            end

            should "contain property state" do
              actual = @address_node.xpath('State')[0].content
              assert_equal @community.state.code, actual
            end

            should "contain property postal code" do
              actual = @address_node.xpath('PostalCode')[0].content
              assert_equal @community.zip_code, actual
            end

            should "contain property county name" do
              actual = @address_node.xpath('CountyName')[0].content
              assert_equal @community.county.name, actual
            end

            should "contain property email" do
              actual = @address_node.xpath('Lead2LeaseEmail')[0].content
              assert_equal @community.lead_2_lease_email, actual
            end
          end

          should "contain property phone number" do
            actual = @property_id_node.xpath('Phone[@Type="office"]//PhoneNumber')[0].content
            assert_equal @community.phone_number, actual
          end
        end

        context "with features" do
          setup do
            path = '//PhysicalProperty//Property//Feature'
            @feature_node = @doc.xpath(path)[0]
          end

          should "contain feature title" do
            assert_equal 'Features', @feature_node.xpath('Title')[0].content
          end

          should "contain feature text" do
            assert_equal 'Here lies some features',
              @feature_node.xpath('Description')[0].content
          end
        end

        context "with feature buttons" do
          setup do
            path = '//PhysicalProperty//Property//FeaturedButton'
            @featured_button_node = @doc.xpath(path)[0]
          end

          should "contain name" do
            assert_equal 'Feature Uno',
              @featured_button_node.xpath('Name')[0].content
          end
        end

        context "within Information node" do
          setup do
            path = '//PhysicalProperty//Property//Information'
            @information_node = @doc.xpath(path)[0]
          end

          context "with office hours" do
            setup do
              @office_hour_node = @information_node.xpath('OfficeHour')[0]
            end

            should "contain open time" do
              assert_equal '9:00 AM',
                @office_hour_node.xpath('OpenTime')[0].content
            end

            should "contain close time" do
              assert_equal '6:00 PM',
                @office_hour_node.xpath('CloseTime')[0].content
            end

            should "contain day" do
              assert_equal 'Monday',
                @office_hour_node.xpath('Day')[0].content
            end
          end

          should "contain overview text" do
            assert_equal @overview_text,
              @information_node.xpath('OverviewText')[0].content
          end

          should "contain overview text stripped" do
            assert_equal 'dolan haev u seen pluto? i jsut find him yay where is he?',
              @information_node.xpath('OverviewTextStripped')[0].content
          end

          1.upto(3) do |n|
            should "contain overview bullet #{n}" do
              assert_equal "ovrvu bulet #{n}",
                @information_node.xpath("OverviewBullet#{n}")[0].content
            end
          end

          should "contain neighborhood text" do
            assert_equal 'wilcum to da hood',
              @information_node.xpath('NeighborhoodText')[0].content
          end

          should "contain directions link" do
            assert_equal 'http://maps.google.com/maps?daddr=100%20Gooby%20Pls,%20Bogsville,%20NC',
              @information_node.xpath('DirectionsURL')[0].content
          end

          should "contain local info rss feed" do
            assert_equal 'http://bozzuto.com/feed',
              @information_node.xpath('LocalInfoRSSURL')[0].content
          end

          should "contain property listing image" do
            actual = @information_node.xpath('ListingImageURL')[0].content
            assert_match %r{http://bozzuto\.com/system/apartment_communities/\d+/square\.jpg}, actual
          end

          should "contain video url" do
            assert_equal 'http://www.videoapt.com/208/LibertyTowers/Default.aspx',
              @information_node.xpath('VideoURL')[0].content
          end

          should "contain facebook url" do
            assert_equal 'http://facebook.com/dafuq',
              @information_node.xpath('FacebookURL')[0].content
          end

          should "contain twitter handle" do
            assert_equal 'TheBozzutoGroup',
              @information_node.xpath('TwitterHandle')[0].content
          end

          should "contain pinterest url" do
            assert_equal 'http://pinterest.com/bozzuto',
              @information_node.xpath('PinterestURL')[0].content
          end
        end

        context "with Nearby Apartment Communities" do
          setup do
            @nearby_community = @community.nearby_communities.included_in_export.first

            path = '//PhysicalProperty//Property//NearbyCommunity'
            @nearby_node = @doc.xpath(path)[0]
          end

          should "contain id" do
            assert_equal @nearby_community.id.to_s, @nearby_node['Id']
          end

          should "contain title" do
            assert_equal @nearby_community.title,
              @nearby_node.xpath('Name')[0].content
          end
        end

        context "with slideshow" do
          setup do
            path = '//PhysicalProperty//Property//Slideshow'
            @slideshow_node = @doc.xpath(path)[0]
          end

          should "contain an image URL" do
            assert_equal "http://bozzuto.com#{@slide.image.url(:slide)}",
              @slideshow_node.xpath('SlideshowImageURL')[0].content
          end
        end

        context "with floor plans" do
          setup do
            path = "//PhysicalProperty//Property//Floorplan[@Id=\"#{@floor_plan.id}\"]"
            @floor_plan_node = @doc.xpath(path)[0]
          end

          should "contain name" do
            assert_equal 'The Roxy', @floor_plan_node.xpath('Name')[0].content
          end

          should "contain min market rent" do
            assert_equal '2260', @floor_plan_node.xpath('MarketRent')[0]['Min']
          end

          should "contain max market rent" do
            assert_equal '2300', @floor_plan_node.xpath('MarketRent')[0]['Max']
          end

          should "contain minimum effective rent" do
            assert_equal '2260',
              @floor_plan_node.xpath('EffectiveRent')[0]['Min']
          end

          should "contain maximum effective rent" do
            assert_equal '2300',
              @floor_plan_node.xpath('EffectiveRent')[0]['Max']
          end

          should "contain minimum square footage" do
            assert_equal '1400', @floor_plan_node.xpath('SquareFeet')[0]['Min']
          end

          should "contain maximum square footage" do
            assert_equal '1400', @floor_plan_node.xpath('SquareFeet')[0]['Max']
          end

          should "contain availability url" do
            assert_equal 'http://lol.wut',
              @floor_plan_node.xpath('FloorplanAvailabilityURL')[0].content
          end

          should "contain available units" do
            assert_equal '3',
              @floor_plan_node.xpath('DisplayedUnitsAvailable')[0].content
          end

          should "contain image url" do
            assert_match %r{http://bozzuto\.com/system/apartment_floor_plans/\d+/original\.jpg},
              @floor_plan_node.xpath('ImageURL')[0].content
          end

          should "contain number of bedrooms" do
            assert_equal '3', @floor_plan_node.xpath('Bedrooms')[0].content
          end

          should "contain number of bathrooms" do
            assert_equal '2.0', @floor_plan_node.xpath('Bathrooms')[0].content
          end
        end

        context "with promotion" do
          setup do
            path = '//PhysicalProperty//Property//Promotion'
            @promotion_node = @doc.xpath(path)[0]
          end

          should "contain title" do
            assert_equal 'on sale meow',
              @promotion_node.xpath('Title')[0].content
          end

          should "contain subtitle" do
            assert_equal 'come on down',
              @promotion_node.xpath('Subtitle')[0].content
          end

          should "contain link url" do
            assert_equal 'http://buy.now',
              @promotion_node.xpath('LinkURL')[0].content
          end

          context "with expiration date" do
            setup do
              @expiration_date_node = @promotion_node.xpath('ExpirationDate')[0]
            end

            should "contain month" do
              expected = @expiration_date.strftime('%m')
              assert_equal expected, @expiration_date_node['Month']
            end

            should "contain day" do
              expected = @expiration_date.strftime('%d')
              assert_equal expected, @expiration_date_node['Day']
            end

            should "contain year" do
              expected = @expiration_date.strftime('%Y')
              assert_equal expected, @expiration_date_node['Year']
            end
          end
        end

        should "render multiple communities" do
          5.times { |n| ApartmentCommunity.make }
          path = '//PhysicalProperty//Property'
          doc = Nokogiri::XML(@exporter.to_xml)

          assert_equal 7, doc.xpath(path).size
        end
      end
    end
  end
end
