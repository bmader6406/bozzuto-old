require 'test_helper'

class FeaturesControllerTest < ActionController::TestCase
  context 'a GET to #show' do
    context 'with a home community' do
      setup do
        @community = HomeCommunity.make
      end

      browser_context do
        setup do
          get :show, :home_community_id => @community.to_param
        end

        should_respond_with :success
        should_render_with_layout :community
        should_render_template :show
        should_assign_to(:community) { @community }
      end

      mobile_context do
        setup do
          get :show,
            :home_community_id => @community.to_param,
            :format => :mobile
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

      browser_context do
        setup do
          get :show, :apartment_community_id => @community.to_param
        end

        should_respond_with :success
        should_render_with_layout :community
        should_render_template :show
        should_assign_to(:community) { @community }
      end

      mobile_context do
        setup do
          get :show,
            :apartment_community_id => @community.to_param,
            :format => :mobile
        end

        should_respond_with :success
        should_render_with_layout :application
        should_render_template :show
        should_assign_to(:community) { @community }
      end
    end
  end
end
