require 'test_helper'

class CitiesControllerTest < ActionController::TestCase
  context 'CitiesController' do
    before do
      @city = City.make

      @published   = ApartmentCommunity.make(:city => @city)
      @unpublished = ApartmentCommunity.make(:unpublished, :city => @city)
    end

    describe "GET to #show" do
      desktop_device do
        before do
          get :show, :id => @city.to_param
        end

        should respond_with(:redirect)
        should redirect_to('the metros page') { metros_url }
      end

      mobile_device do
        before do
          get :show, :id => @city.to_param
        end

        should respond_with(:success)
        should render_template(:show)
        should assign_to(:city) { @city }
        should assign_to(:apartment_communities) { [@published] }
      end
    end
  end
end
