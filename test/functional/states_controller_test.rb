require 'test_helper'

class StatesControllerTest < ActionController::TestCase
  context "StatesController" do
    before do
      @state     = State.make
    end

    describe "GET to #show" do
      all_devices do
        before do
          get :show, :id => @state.to_param
        end

        should_respond_with(:success)
        should_render_template(:show)
      end
    end
  end
end
