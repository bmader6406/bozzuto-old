require 'test_helper'

class CitiesControllerTest < ActionController::TestCase
  context 'CitiesController' do
    setup do
      @city = City.make

      @published   = ApartmentCommunity.make(:city => @city)
      @unpublished = ApartmentCommunity.make(:unpublished, :city => @city)
    end
    
    context '#show for mobile' do
      setup do
        get :show, :id => @city.to_param, :format => 'mobile'
      end
      
      should_respond_with :success
      should_render_template :show
      should_assign_to(:city) { @city }
      should_assign_to(:apartment_communities) { [@published] }
    end
  end
end
