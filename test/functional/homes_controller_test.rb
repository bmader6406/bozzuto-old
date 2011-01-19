require 'test_helper'

class HomesControllerTest < ActionController::TestCase
  context "HomesController" do
    setup do
      @community = HomeCommunity.make
    end

    context "a GET to #index" do
      browser_context do
        setup do
          get :index, :home_community_id => @community.id
        end

        should_respond_with :success
        should_render_with_layout :community
        should_render_template :index
        should_assign_to(:community) { @community }
      end

      mobile_context do
        setup do
          get :index,
            :home_community_id => @community.id,
            :format => :mobile
        end

        should_respond_with :success
        should_render_with_layout :application
        should_render_template :index
        should_assign_to(:community) { @community }
      end
    end
  end
end
