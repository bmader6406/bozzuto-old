require 'test_helper'

class CommunitiesControllerTest < ActionController::TestCase
  context "a GET to #show" do
    setup do
      @community = Community.make
      get :show, :id => @community.id
    end

    should_assign_to(:community) { @community }
    should_respond_with :success
    should_render_template :show
  end
end
