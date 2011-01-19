require 'test_helper'

class CountiesControllerTest < ActionController::TestCase
  context 'CountiesController' do
    setup do
      @community = ApartmentCommunity.make
      @city = @community.city
      @state = @city.state
      @county = County.make(:state => @state)
      @county.cities << @city
    end
    
    context '#index for mobile' do
      setup do
        get :index, :state_id => @state.to_param, :format => 'mobile'
      end
      
      should_respond_with :success
      should_render_template :index
      should_assign_to(:state){ @state }
    end
    
    context '#show for mobile' do
      setup do
        get :show, :id => @county.to_param, :format => 'mobile'
      end
      
      should_respond_with :success
      should_render_template :show
      should_assign_to(:county){ @county }
    end
  end
end
