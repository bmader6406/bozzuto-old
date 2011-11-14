require 'test_helper'

class SearchesControllerTest < ActionController::TestCase
  context 'GET to #index' do
    browser_context do
      context 'with query present' do
        setup do
          search = Object.new
          search.stubs(:results).returns([])
          BOSSMan::Search.stubs(:web).returns(search)

          get :index, :q => 'shake it like a polaroid picture'
        end

        should_respond_with :success
        should_render_template :index
      end

      context 'without query present' do
        setup do
          get :index
        end

        should_respond_with :redirect
        should_redirect_to(:home_page) { root_path }
      end
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
