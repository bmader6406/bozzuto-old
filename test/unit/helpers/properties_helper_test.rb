require 'test_helper'

class PropertiesHelperTest < ActionView::TestCase
  include OverriddenPathsHelper

  context "PropertiesHelper" do
    context '#mobile_map_url' do
      setup do
        @community = ApartmentCommunity.make :latitude => rand, :longitude => rand
      end

      context 'on an iPhone' do
        should 'return the map url' do
          url = "http://maps.google.com/maps?q=#{@community.latitude},#{@community.longitude}"
          stubs(:device).returns(:iphone)

          assert_equal url, mobile_map_url(@community)
        end
      end

      context 'on Android' do
        should 'return the map url' do
          url = "geo:#{@community.latitude},#{@community.longitude}"
          stubs(:device).returns(:android)

          assert_equal url, mobile_map_url(@community)
        end
      end

      context 'on BlackBerry' do
        should 'return the map url' do
          url = apartment_community_path(@community, :format => :kml)
          stubs(:device).returns(:blackberry)

          assert_equal url, mobile_map_url(@community)
        end
      end
    end

    context '#brochure_link' do
      setup do
        @link_text = 'Click me'
        @property = Property.new :brochure_link_text => @link_text
      end

      context 'when the property has no brochure_link_text' do
        should 'return nil' do
          assert_nil brochure_link(@property)
        end
      end

      context 'when the property uses brochure url' do
        setup do
          @url = 'http://viget.com'
          @property.brochure_url = @url
        end

        should 'return a link with the brochure url' do
          link = HTML::Document.new(brochure_link(@property))
          assert_select link.root, 'a',
            :href => @url,
            :text => @link_text
        end
      end

      context 'when the property uses brochure file' do
        setup do
          @file = 'http://viget.com/file.jpg'
          @property.brochure_type = Property::USE_BROCHURE_FILE
          @property.brochure = mock()
          @property.brochure.expects(:url).returns(@file)
        end

        should 'return a link with the brochure file url' do
          link = HTML::Document.new(brochure_link(@property))
          assert_select link.root, 'a',
            :href => @file,
            :text => @link_text
        end
      end
    end

    context 'icons' do
      context "#property_icons" do
        setup do
          @community = ApartmentCommunity.make
          3.times { @community.property_features << PropertyFeature.make }
        end

        should "emit icons for the community's features" do
          icons = HTML::Document.new(property_icons(@community))

          assert_select icons.root, "ul.community-icons"

          @community.property_features.each do |feature|
            assert_select icons.root, "a",
              :href => "##{dom_id(feature)}",
              :text => feature.name
          end
        end
      end

      context "#property_icon_descriptions" do
        setup do
          3.times { PropertyFeature.make }
          @features = PropertyFeature.all
        end

        should "emit icons for the community's features" do
          icons = HTML::Document.new(property_icon_descriptions)

          assert_select icons.root, "ul#icon-tooltips"

          @features.each do |feature|
            assert_select icons.root, "li##{dom_id(feature)}"
            assert_select icons.root, "li h4", feature.name
          end
        end
      end
    end

    context "#property_bullets" do
      setup do
        @bullet_1 = 'Here is some bullet 1 text'
        @bullet_2 = 'Bullet 2 text'
        @community = ApartmentCommunity.make(
          :overview_bullet_1 => @bullet_1,
          :overview_bullet_2 => @bullet_2
        )
      end

      should "emit icons for true flags on the community" do
        bullets = HTML::Document.new(property_bullets)
        assert_select bullets.root, 'li', :count => 2
        assert_select bullets.root, 'li', :text => @bullet_1
        assert_select bullets.root, 'li', :text => @bullet_2
      end
    end
  end
end
