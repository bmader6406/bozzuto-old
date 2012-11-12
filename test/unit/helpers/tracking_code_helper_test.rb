require 'test_helper'

class TrackingCodeHelperTest < ActionView::TestCase
  should "output the ValueClick tracking code" do
    assert_match /ValueClick/, value_click_tracking_code
  end

  context "#rtrk_code" do
    setup do
      @community = ApartmentCommunity.make
    end

    should "return code if community can show it" do
      @community.show_rtrk_code = true

      assert_match /rtrk\.com/, rtrk_code(@community)
    end

    should "return nil if community cannot show it" do
      @community.show_rtrk_code = false

      assert_nil rtrk_code(@community)
    end
  end
end
