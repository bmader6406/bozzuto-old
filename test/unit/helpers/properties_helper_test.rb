require 'test_helper'

class PropertiesHelperTest < ActionView::TestCase
  context "PropertiesHelper" do
    context 'icons' do
      context "#property_icons" do
        setup do
          @community = ApartmentCommunity.make
          3.times { @community.property_features << PropertyFeature.make }
        end

        should "emit icons for the community's features" do
          icons = HTML::Document.new(property_icons)

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
          @community = ApartmentCommunity.make
          3.times { @community.property_features << PropertyFeature.make }
        end

        should "emit icons for the community's features" do
          icons = HTML::Document.new(property_icon_descriptions)

          assert_select icons.root, "ul#icon-tooltips"

          @community.property_features.each do |feature|
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
