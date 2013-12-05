require 'test_helper'

class CitiesControllerTest < ActionController::TestCase
  context 'CitiesController' do
    setup do
      @city = City.make

      @published   = ApartmentCommunity.make(:city => @city)
      @unpublished = ApartmentCommunity.make(:unpublished, :city => @city)
    end

    context 'a GET to #show' do
      desktop_device do
        setup do
          get :show, :id => @city.to_param
        end

        should_respond_with :redirect
        should_redirect_to('the apartment communities page') { apartment_communities_url }
      end

      mobile_device do
        setup do
          get :show, :id => @city.to_param
        end

        should_respond_with :success
        should_render_template :show
        should_assign_to(:city) { @city }
        should_assign_to(:apartment_communities) { [@published] }
      end
    end
  end
end
