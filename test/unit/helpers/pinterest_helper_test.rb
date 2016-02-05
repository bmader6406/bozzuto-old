require 'test_helper'

class PinterestHelperTest < ActionView::TestCase
  context "#pinterest_button" do
    setup do
      @url         = 'http://bozzuto.com/yay?hooray=1'
      @image       = 'http://bozzuto.com/images/thing.jpg'
      @description = '#yay'
    end

    should "return the button html" do
      button = pinterest_button(@url, @image, @description)

      button.should include(URI::encode(@url))
      button.should include('<span class="pinterest-button">')
      button.should include(URI::encode(@image))
      button.should include(URI::encode(@description))
    end
  end
end
