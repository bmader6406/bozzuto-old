require 'test_helper'

class CitiesControllerTest < ActionController::TestCase
  context 'CountiesController' do
    setup do
      @community = ApartmentCommunity.make
      @city = @community.city
      @state = @city.state
      @county = County.make(:state => @state)
      @county.cities << @city
    end
    
    context '#show for mobile' do
      setup do
        get :show, :id => @city.to_param, :format => 'mobile'
      end
      
      should_respond_with :success
      should_render_template :show
      should_assign_to(:city){ @city }
    end
  end
end
