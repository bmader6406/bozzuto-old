require 'test_helper'

class StatesControllerTest < ActionController::TestCase
  context 'StatesController' do
    setup do
      @state = State.make
    end

    context 'a GET to #show' do
      setup do
        get :show, :id => @state.to_param
      end

      should_respond_with :success
      should_render_template :show
      should_assign_to(:state) { @state }
      should_assign_to(:cities) { @state.cities.ordered_by_name }
      should_assign_to(:counties) { @state.counties.ordered_by_name }
    end
  end
end
