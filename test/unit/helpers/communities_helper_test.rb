require 'test_helper'

class CommunitiesHelperTest < ActionView::TestCase
  include OverriddenPathsHelper

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
        assert_match /script.*var google_conversion_label = "12345";/m, google_conversion_code('12345')
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
        assert_match /script.*actionid:"12345"/m, bing_conversion_code('12345')
      end
    end
  end

  context '#schedule_tour_link' do
    setup do
      @community = ApartmentCommunity.make
    end

    context 'community does not have a schedule tour url' do
      setup do
        @community.schedule_tour_url = nil
        @link = schedule_tour_link(@community)
      end

      should 'link to the contact page' do
        assert_match /#{contact_community_path(@community)}/, @link
      end

      should 'not include the data attributes' do
        assert_no_match /data-iframe="yes"/, @link
        assert_no_match /data-width="800"/, @link
        assert_no_match /data-height="600"/, @link
      end
    end

    context 'community does have a schedule tour url' do
      setup do
        @community.schedule_tour_url = 'http://batman.com'
        @link = schedule_tour_link(@community)
      end

      should 'link to the schedule tour url' do
        assert_match /#{@community.schedule_tour_url}/, @link
      end

      should 'include the data attributes' do
        assert_match /data-iframe="yes"/, @link
        assert_match /data-width="800"/, @link
        assert_match /data-height="600"/, @link
      end
    end
  end
end
