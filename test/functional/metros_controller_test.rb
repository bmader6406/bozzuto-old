require 'test_helper'

class MetrosControllerTest < ActionController::TestCase
  context "MetrosController" do
    all_devices do
      describe "GET to #index" do
        before do
          @metro = Metro.make
          @other = Metro.make

          @area       = Area.make(:metro => @metro)
          @community  = ApartmentCommunity.make
          @membership = AreaMembership.make(:area => @area, :apartment_community => @community)

          get :index
        end

        should respond_with(:success)
        should render_template(:index)
        should assign_to(:metros) { [@metro] }
      end

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
