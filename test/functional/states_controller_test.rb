require 'test_helper'

class StatesControllerTest < ActionController::TestCase
  context 'StatesController' do
    setup do
      @state     = State.make
      @city      = City.make :state => @state
      @community = ApartmentCommunity.make :city => @city
    end

    context 'a GET to #show' do
      desktop_device do
        setup do
          get :show, :id => @state.to_param
        end

        should_respond_with :redirect
        should_redirect_to('the apartment communities page') { apartment_communities_url }
      end

      mobile_device do
        setup do
          get :show, :id => @state.to_param, :format => 'mobile'
        end

        should_respond_with :success
        should_render_template :show
        should_assign_to(:state) { @state }
        should_assign_to(:cities) { @state.cities.ordered_by_name }
      end
    end
  end
end
