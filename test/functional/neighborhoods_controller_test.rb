require 'test_helper'

class NeighborhoodsControllerTest < ActionController::TestCase
  context 'a GET to #show' do
    context 'with a home community' do
      setup do
        @community = HomeCommunity.make
      end

      context 'from a browser' do
        setup do
          get :show, :home_community_id => @community.to_param
        end

        should_respond_with :success
        should_render_with_layout :community
        should_render_template :show
        should_assign_to(:community) { @community }
      end

      context 'from a mobile device' do
        setup do
          set_mobile_user_agent!
          get :show, :home_community_id => @community.to_param
        end

        should_respond_with :success
        should_render_with_layout :application
        should_render_template :show
        should_assign_to(:community) { @community }
      end
    end


    context 'with an apartment community' do
      setup do
        @community = ApartmentCommunity.make
      end

      context 'from a browser' do
        setup do
          get :show, :apartment_community_id => @community.to_param
        end

        should_respond_with :success
        should_render_with_layout :community
        should_render_template :show
        should_assign_to(:community) { @community }
      end

      context 'from a mobile device' do
        setup do
          set_mobile_user_agent!
          get :show, :apartment_community_id => @community.to_param
        end

        should_respond_with :success
        should_render_with_layout :application
        should_render_template :show
        should_assign_to(:community) { @community }
      end
    end
  end
end
