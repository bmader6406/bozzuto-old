require 'test_helper'

class NeighborhoodsControllerTest < ActionController::TestCase
  context 'a GET to #show' do
    context 'with a home community' do
      setup do
        @community = HomeCommunity.make
        get :show, :home_community_id => @community.to_param
      end

      should_respond_with :success
      should_render_template :show
      should_assign_to(:community) { @community }
    end

    context 'with an apartment community' do
      setup do
        @community = ApartmentCommunity.make
        get :show, :apartment_community_id => @community.to_param
      end

      should_respond_with :success
      should_render_template :show
      should_assign_to(:community) { @community }
    end
  end
end
