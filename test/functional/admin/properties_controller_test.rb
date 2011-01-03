require 'test_helper'

class Admin::PropertiesControllerTest < ActionController::TestCase     
  context 'Admin::PropertiesController' do
    setup do
      @user = TypusUser.make
      login_typus_user @user
      @community = ApartmentCommunity.make
      @community.destroy
    end
    
    context 'get #recover' do
      setup do
        get :recover, :id => @community.id
      end
      
      should_respond_with :redirect
      should_assign_to :property
      
      should_change 'ApartmentCommunity count', :by => 1 do
        ApartmentCommunity.count
      end
      
      should_change 'ApartmentCommunity count', :by => -1 do
        ApartmentCommunity::Archive.count
      end
    end
  end
end