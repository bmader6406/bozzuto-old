require 'test_helper'

class RedesignHelperTest < ActionView::TestCase
  context '#icon' do
    should "return the icon html" do
      assert_equal '<i aria-hidden="true" class="ico">a</i>', icon('a')
    end
  end
end
