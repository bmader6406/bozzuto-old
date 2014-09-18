require 'test_helper'

class HomeNeighborhoodsControllerTest < ActionController::TestCase
  context "HomeNeighborhoodsController" do
    all_devices do
      describe "GET to #show" do
        before do
          @neighborhood = HomeNeighborhood.make

          get :show, :id => @neighborhood.to_param
        end

        should respond_with(:success)
        should render_template(:show)
        should assign_to(:neighborhood) { @neighborhood }
      end

      describe "GET to #index" do
        before do
          @neighborhoods = [HomeNeighborhood.make, HomeNeighborhood.make]

          get :index
        end

        should respond_with(:success)
        should render_template(:index)
        should assign_to(:neighborhoods) { @neighborhoods }
      end
    end
  end
end
