require 'test_helper'

class FloorPlanGroupsControllerTest < ActionController::TestCase
  context "FloorPlanGroupsController" do
    setup do
      @community = ApartmentCommunity.make
    end

    context "a GET to #index" do
      setup do
        get :index, :apartment_community_id => @community.id
      end

      should_respond_with :success
      should_render_template :index
      should_assign_to(:community) { @community }
      should_assign_to(:groups) { FloorPlanGroup.all }
    end
  end
end
