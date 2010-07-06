require 'test_helper'

class PropertiesHelperTest < ActionView::TestCase
  context "PropertiesHelper" do
    context "#property_icons" do
      setup do
        @community = ApartmentCommunity.make(:elite => true, :non_smoking => true)
      end

      should "emit icons for true flags on the community" do
        icons = HTML::Document.new(property_icons)
        assert_select icons.root, "ul.community-icons"
        assert_select icons.root, "li.elite"
        assert_select icons.root, "li.non-smoking"
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
