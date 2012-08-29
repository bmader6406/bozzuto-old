require 'test_helper'

class TrackingCodeHelperTest < ActionView::TestCase
  should "output the ValueClick tracking code" do
    assert_match /ValueClick/, value_click_tracking_code
  end
end
