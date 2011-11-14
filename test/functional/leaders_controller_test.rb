require 'test_helper'

class LeadersControllerTest < ActionController::TestCase
  context 'LeadersController' do
    setup do
      @section = Section.make(:about)
    end

    context 'a GET to #index' do
      browser_context do
        setup do
          get :index, :section => @section.to_param
        end

        should_respond_with :success
        should_render_template :index
      end

      mobile_context do
        setup do
          set_mobile_user_agent!

          get :index, :section => @section.to_param
        end

        should_redirect_to_home_page
      end
    end
  end
end
