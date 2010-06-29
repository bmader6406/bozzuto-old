require 'test_helper'

class HomeCommunitiesControllerTest < ActionController::TestCase
  context 'HomeCommunitiesControllerTest' do
    setup do
      @section = Section.make :title => 'New Homes'
    end

    context 'a GET to #index' do
      setup do
        5.times { HomeCommunity.make }
        @communities = HomeCommunity.ordered_by_title.all(:limit => 4)

        get :index
      end

      should_respond_with :success
      should_render_template :index
      should_assign_to(:section) { @section }
      should_assign_to(:communities) { @communities }
    end

    context 'a GET to #show' do
      setup do
        @community = HomeCommunity.make
        get :show, :id => @community.id
      end

      should_respond_with :success
      should_render_template :show
      should_assign_to(:section) { @section }
      should_assign_to(:community) { @community }
    end
  end
end
