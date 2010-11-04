require 'test_helper'

class ApartmentCommunitiesControllerTest < ActionController::TestCase
  context "ApartmentCommunitiesController" do
    setup { @community = ApartmentCommunity.make }

    context 'get #index' do
      context 'for the search view' do
        setup do
          get :index
        end

        should_respond_with :success
        should_render_template :index
      end

      context 'for the map view' do
        setup do
          get :index, :template => 'map'
        end

        should_respond_with :success
        should_render_template :index
      end
    end

    context "a GET to #show" do
      setup do
        get :show, :id => @community.to_param
      end

      should_assign_to(:community) { @community }
      should_respond_with :success
      should_render_template :show
    end
  end
end
