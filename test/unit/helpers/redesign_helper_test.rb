require 'test_helper'

class RedesignHelperTest < ActionView::TestCase
  context '#icon' do
    should "return the icon html" do
      icon('a').should eq '<i class="ico" aria-hidden="true">a</i>'
    end
  end
end
