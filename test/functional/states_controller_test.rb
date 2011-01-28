require 'test_helper'

class StatesControllerTest < ActionController::TestCase
  context 'StatesController' do
    setup do
      @community = ApartmentCommunity.make
      @city = @community.city
      @state = @city.state
      @county = County.make(:state => @state)
      @county.cities << @city
    end

    context 'a GET to #show' do
      browser_context do
        setup do
          get :show, :id => @state.to_param
        end

        should_respond_with :redirect
        should_redirect_to('the apartment communities page') { apartment_communities_url }
      end

      mobile_context do
        setup do
          get :show, :id => @state.to_param, :format => 'mobile'
        end

        should_respond_with :success
        should_render_template :show
        should_assign_to(:state){ @state }
      end
    end
  end
end
