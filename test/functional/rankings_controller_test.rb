require 'test_helper'

class RankingsControllerTest < ActionController::TestCase
  context 'RankingsController' do
    setup do
      @section = Section.make(:about)
      @page    = Page.make :title => 'Rankings', :section => @section
    end

    context 'a GET to #index' do
      browser_context do
        setup do
          get :index
        end

        should_respond_with :success
        should_render_template :index
      end

      mobile_context do
        setup do
          set_mobile_user_agent!
          get :index
        end

        should_redirect_to_home_page
      end
    end
  end
end
