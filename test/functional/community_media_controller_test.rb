require 'test_helper'

class CommunityMediaControllerTest < ActionController::TestCase
  context 'CommunityMediaController' do
    context 'a GET to #index' do
      setup do
        @community = ApartmentCommunity.make
        get :index, :apartment_community_id => @community.id
      end

      should_respond_with :success
      should_render_template :index
      should_assign_to(:community) { @community }
    end
  end
end
