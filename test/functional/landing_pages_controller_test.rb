require 'test_helper'

class LandingPagesControllerTest < ActionController::TestCase
  context 'LandingPagesController' do
    context 'a GET to #show' do
      setup do
        @page = LandingPage.create :title => 'Landing page'
        get :show, :id => @page.to_param
      end

      should_respond_with :success
      should_render_template :show
      should_assign_to(:page) { @page }
    end
  end
end
