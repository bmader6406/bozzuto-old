require 'test_helper'

class LeadersControllerTest < ActionController::TestCase
  context 'LeadersController' do
    setup do
      @section = Section.make(:about)
    end

    context 'a GET to #index' do
      all_devices do
        setup do
          get :index, :section => @section.to_param
        end

        should_respond_with :success
        should_render_template :index
      end
    end
  end
end
