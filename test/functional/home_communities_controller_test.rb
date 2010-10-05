require 'test_helper'

class HomeCommunitiesControllerTest < ActionController::TestCase
  context 'HomeCommunitiesControllerTest' do
    setup do
      @section = Section.make :title => 'New Homes'
      @community = HomeCommunity.make
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

    %w(show features).each do |action|
      context "a GET to ##{action}" do
        setup do
          get action, :id => @community.to_param
        end

        should_assign_to(:community) { @community }
        should_respond_with :success
        should_render_template action
      end
    end
  end
end
