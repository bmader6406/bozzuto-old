require 'test_helper'

class ServicesControllerTest < ActionController::TestCase
  context 'ServicesController' do
    setup do
      @service = Service.make
    end

    context 'a GET to #show' do
      setup do
        get :show, :id => @service.to_param
      end

      should_respond_with :success
      should_render_template :show
      should_assign_to(:service) { @service }
    end
  end
end
