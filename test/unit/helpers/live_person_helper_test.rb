require 'test_helper'

class LivePersonHelperTest < ActionView::TestCase
  context "#live_person_js" do
    it "ouputs the Live Person Monitor javascript" do
      assert_match /BEGIN LivePerson Monitor/, live_person_js
      assert_match /END LivePerson Monitor/, live_person_js
    end
  end
end
