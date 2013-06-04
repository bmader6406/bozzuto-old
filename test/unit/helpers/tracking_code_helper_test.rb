require 'test_helper'

class TrackingCodeHelperTest < ActionView::TestCase
  context "#value_click_tracking_code" do
    should "output the correct code" do
      assert_match /ValueClick/, value_click_tracking_code
    end
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

  context "#value_click_apartment_thank_you_code" do
    should "output the correct code" do
      actual = '<img src="http://media.fastclick.net/w/roitrack.cgi?aid=1000044195" width=1 height=1 border=0>'

      assert_equal actual, value_click_apartment_thank_you_code
    end
  end

  context "#facebook_apartment_thank_you_code" do
    should "output the correct code" do
      code = facebook_apartment_thank_you_code

      assert_match /<script type="text\/javascript">.*<\/script>/m, code
      assert_match /fb_param\.pixel_id = '6007551186980';/, code
      assert_match /<noscript>.*<\/noscript>/m, code
    end
  end
end
