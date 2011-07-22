require 'test_helper'

class CommunitiesHelperTest < ActionView::TestCase
  context '#community_contact_callout' do
    setup do
      @community = ApartmentCommunity.make
      expects(:render).with('communities/request_info',  :community => @community)
    end

    should 'render the partial' do
      community_contact_callout(@community)
    end
  end


  context '#mediamind_activity_code' do
    context 'when activity_id is not present' do
      should 'return an empty string' do
        assert_equal '', mediamind_activity_code(nil)
      end
    end

    context 'when activity_id is present' do
      should 'return the JavaScript' do
        assert_match /script.*ActivityID=12345/m, mediamind_activity_code(12345)
      end
    end
  end

  context '#google_conversion_code' do
    context 'when conversion_label is not present' do
      should 'return an empty string' do
        assert_equal'', google_conversion_code(nil)
      end
    end

    context 'when conversion_label is present' do
      should 'return the JavaScript' do
        assert_match /script.*var google_conversion_label = "12345";/m,
          google_conversion_code('12345')
      end
    end
  end

  context '#bing_conversion_code' do
    context 'when action_id is not present' do
      should 'return an empty string' do
        assert_equal'', bing_conversion_code(nil)
      end
    end

    context 'when action_id is present' do
      should 'return the JavaScript' do
        assert_match /script.*actionid:"12345"/m,
          bing_conversion_code('12345')
      end
    end
  end
end
