require 'test_helper'

class ApartmentCommunitiesControllerTest < ActionController::TestCase
  context "ApartmentCommunitiesController" do
    setup do
      @community = ApartmentCommunity.make
      @unpublished_community = ApartmentCommunity.make(:published => false)
    end

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
    
    context 'logged in to typus' do
      setup do
        @user = TypusUser.make
        login_typus_user @user
      end
      
      context "a GET to #show for an upublished community" do
        setup do
          get :show, :id => @unpublished_community.to_param
        end

        should_assign_to(:community) { @unpublished_community }
        should_respond_with :success
        should_render_template :show
      end
    end
  end
end
