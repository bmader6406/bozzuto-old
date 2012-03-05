require 'test_helper'

class ClicktaleHelperTest < ActionView::TestCase
  context '#clicktale_top' do
    should 'output the top ClickTale javascript' do
      assert_match /ClickTale Top part/, clicktale_top
    end

    should 'output the bottom ClickTale javascript' do
      assert_match /ClickTale Bottom part/, clicktale_bottom
    end
  end
end
