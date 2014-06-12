require 'test_helper'

class HomeNeighborhoodsControllerTest < ActionController::TestCase
  context "HomeNeighborhoodsController" do
    all_devices do
      describe "GET to #show" do
        before do
          @neighborhood = HomeNeighborhood.make

          get :show, :id => @neighborhood.to_param
        end

        should_respond_with(:success)
        should_render_template(:show)
        should_assign_to(:neighborhood) { @neighborhood }
      end

      describe "GET to #index" do
        before do
          @neighborhoods = [HomeNeighborhood.make, HomeNeighborhood.make]

          get :index
        end

        should_respond_with(:success)
        should_render_template(:index)
        should_assign_to(:neighborhoods) { @neighborhoods }
      end
    end
  end
end
