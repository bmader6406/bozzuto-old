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

      should "return a floor plan's formatted price" do
        assert_equal "$600.00", floor_plan_price(@plan)
      end
    end
  end
end
