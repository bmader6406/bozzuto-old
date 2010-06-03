require 'test_helper'

class CommunitiesHelperTest < ActionView::TestCase
  context "CommunitiesHelper" do
    context "#community_icons" do
      setup do
        @community = Community.make(:elite => true, :non_smoking => true)
      end

      should "emit icons for true flags on the community" do
        icons = HTML::Document.new(community_icons)
        assert_select icons.root, "ul.community-icons"
        assert_select icons.root, "li.elite"
        assert_select icons.root, "li.non-smoking"
      end
    end

    context "#floor_plan_price" do
      setup do
        @plan = FloorPlan.make(:price => 60000)
      end

      should "return the floor plan's formatted price" do
        assert_equal "$600.00", floor_plan_price(@plan)
      end
    end

    context "#square_feet" do
      setup do
        @plan = FloorPlan.make(:square_feet => 550)
      end

      should "return the floor plan's formatted square footage" do
        assert_equal "#{@plan.square_feet} Sq Ft", square_feet(@plan)
      end
    end

    context "#twitter_data_attr" do
      should "return the twitter username data attribute" do
        assert_equal 'data-twitter-username="vigetlabs"',
          twitter_data_attr('vigetlabs')
      end
    end

    context "#walkscore_map_script" do
      setup do
        @community = Community.make(:street_address => '123 Test Dr')
      end

      should "return the javascript code" do
        assert_match /#{@community.address}/,
          walkscore_map_script(@community)

        assert_match /var ws_width = '500';/,
          walkscore_map_script(@community, :width => 500)

        assert_match /var ws_height = '700';/,
          walkscore_map_script(@community, :height => 700)
      end
    end
  end
end
