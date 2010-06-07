require 'test_helper'

class FloorPlanGroupsControllerTest < ActionController::TestCase
  context "FloorPlanGroupsController" do
    setup do
      @community = Community.make
    end

    context "a GET to #index" do
      setup do
        get :index, :community_id => @community.id
      end

      should_respond_with :success
      should_render_template :index
      should_assign_to(:community) { @community }
      should_assign_to(:groups) { @community.floor_plan_groups }
    end
  end
end
