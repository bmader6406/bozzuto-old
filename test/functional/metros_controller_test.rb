require 'test_helper'

class MetrosControllerTest < ActionController::TestCase
  context "MetrosController" do
    all_devices do
      describe "GET to #show" do
        before do
          @metro = Metro.make

          get :show, :id => @metro.to_param
        end

        should respond_with(:success)
        should render_template(:show)
        should assign_to(:metro) { @metro }
      end
    end
  end
end
