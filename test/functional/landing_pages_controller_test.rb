require 'test_helper'

class LandingPagesControllerTest < ActionController::TestCase
  context 'LandingPagesController' do
    context 'a GET to #show' do
      setup do
        @page = LandingPage.make
        @city = City.make(:state => @page.state)
        @community = ApartmentCommunity.make(:city => @city)
        get :show, :id => @page.to_param
      end

      should_respond_with :success
      should_render_template :show
      should_assign_to(:page) { @page }
      should_assign_to(:state) { @page.state }
    end
  end
end
