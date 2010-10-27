require 'test_helper'

class LassoSubmissionsControllerTest < ActionController::TestCase
  context 'LassoSubmissionsController' do
    setup { @community = HomeCommunity.make }

    context 'a GET to #show' do
      setup do
        get :show, :home_community_id => @community.to_param
      end

      should_respond_with :success
      should_render_template :show
      should_assign_to :community
    end

    context 'a GET to #thank_you' do
      setup do
        get :thank_you, :home_community_id => @community.to_param
      end

      should_respond_with :success
      should_render_template :thank_you
      should_assign_to :community
    end
  end
end
