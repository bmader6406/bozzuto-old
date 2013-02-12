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

      assert_match /<span class="pinterest-button">.*<\/span>/m, button
      assert_match /url=#{url_encode(@url)}/, button
      assert_match /media=#{url_encode(@image)}/, button
      assert_match /description=#{url_encode(@description)}/, button
    end
  end
end
