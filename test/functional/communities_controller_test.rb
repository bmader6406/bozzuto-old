require 'test_helper'

class CommunitiesControllerTest < ActionController::TestCase
  context "CommunitiesController" do
    setup do
      @community = Community.make
    end

    %w(show features media neighborhood promotions contact).each do |action|
      context "a GET to ##{action}" do
        setup do
          get action, :id => @community.id
        end

        should_assign_to(:community) { @community }
        should_respond_with :success
        should_render_template action
      end
    end
  end
end
