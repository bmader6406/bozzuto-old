require 'test_helper'

class SimplifiHelperTest < ActionView::TestCase
  context "#apartment_community_simplifi_code" do
    should "return the correct html" do
      code = apartment_contact_simplifi_code

      assert_match /<script async src="\/\/i.simpli\.fi\/dpx\.js\?/, code
      assert_match /<img src="\/\/i.simpli.fi\/dpx?/, code
    end
  end
end
