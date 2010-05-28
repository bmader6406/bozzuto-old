require 'test_helper'

class CommunitiesHelperTest < ActionView::TestCase
  context "CommunitiesHelper" do
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
end
