require 'test_helper'

class HomeCommunitiesControllerTest < ActionController::TestCase
  context 'HomeCommunitiesControllerTest' do
    setup do
      @section = Section.make :title => 'New Homes'
      @community = HomeCommunity.make
      @unpublished_community = HomeCommunity.make(:published => false)
    end

    context 'a GET to #index' do
      setup do
        5.times { HomeCommunity.make }
        @communities = HomeCommunity.published.ordered_by_title.all(:limit => 6)

        get :index
      end

      should_respond_with :success
      should_render_template :index
      should_assign_to(:section) { @section }
      should_assign_to(:communities) { @communities }
    end

    context 'a GET to #map' do
      setup do
        5.times { HomeCommunity.make }
        @communities = HomeCommunity.published.ordered_by_title.all
        get :map
      end

      should_respond_with :success
      should_render_template :map
      should_assign_to(:section) { @section }
      should_assign_to(:communities) { @communities }
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
