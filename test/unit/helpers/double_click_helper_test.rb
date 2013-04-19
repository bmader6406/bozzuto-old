require 'test_helper'

class DoubleClickHelperTest < ActionView::TestCase
  context "#double_click_community_thank_you_script" do
    setup do
      @community = ApartmentCommunity.new(:title => 'Yay Hooray')
    end

    should "return the correct script" do
      script = double_click_community_thank_you_script(@community)

      assert_match /u1=Yay%20Hooray/, script
      assert_match /cat=conta168/, script
      assert_match /Contact Info Complete/, script
    end
  end

  context "#double_click_data_attrs" do
    should "return the data attrs" do
      attrs = double_click_data_attrs('Yay Hooray', '123')

      assert_equal({
        :'data-doubleclick-name' => 'Yay%20Hooray',
        :'data-doubleclick-cat'  => '123'
      }, attrs)
    end
  end
end
