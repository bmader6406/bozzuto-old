require 'test_helper'

class PropertiesHelperTest < ActionView::TestCase
  include OverriddenPathsHelper

  context "PropertiesHelper" do
    context '#mobile_map_url' do
      setup do
        @community = ApartmentCommunity.make
      end

      it "returns the map url" do
        url = "http://maps.google.com/maps?q=#{@community.address}"

        assert_equal url, mobile_map_url(@community)
      end
    end

    context '#directions_url' do
      setup do
        @address = [
          Faker::Address.street_address,
          Faker::Address.city,
          Faker::Address.us_state
        ].join(' ,')
      end

      should 'return a Google Maps link with destination address' do
        assert_equal "http://maps.google.com/maps?daddr=#{URI.escape(@address)}",
          directions_url(@address)
      end
    end

    context '#brochure_link' do
      setup do
        @link_text = 'Click me'
        @property = Property.make(:brochure_link_text => @link_text)
      end

      context 'when the property has no brochure_link_text' do
        before do
          @property.brochure_link_text = nil
        end

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
          html = Nokogiri::HTML(brochure_link(@property))
          link = html.at('a.fl-record-click')

          link.attributes['href'].value.should      == @url
          link.attributes['data-cat'].value.should  == 'digit734'
          link.attributes['data-prop'].value.should == @property.title
          link.text.should == @link_text
        end
      end

      context 'when the property uses brochure file' do
        setup do
          @file = 'http://viget.com/file.jpg'
          @property.brochure.expects(:url).returns(@file)
        end

        should 'return a link with the brochure file url' do
          html = Nokogiri::HTML(brochure_link(@property))
          link = html.at('a.fl-record-click')

          link.attributes['href'].value.should      == @file
          link.attributes['data-cat'].value.should  == 'digit734'
          link.attributes['data-prop'].value.should == @property.title
          link.text.should == @link_text
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
          html = Nokogiri::HTML(property_icons(@community))

          @community.property_features.each do |feature|
            html.at("a[@href='##{dom_id(feature)}']").text.should == feature.name
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
        html    = Nokogiri::HTML(property_bullets)
        bullets = html.xpath('//li')

        bullets.size.should       == 2
        bullets.first.text.should == @bullet_1
        bullets.last.text.should  == @bullet_2
      end
    end
  end
end
