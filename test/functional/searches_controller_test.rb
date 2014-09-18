require 'test_helper'

class SearchesControllerTest < ActionController::TestCase
  context 'GET to #index' do
    all_devices do
      context 'with query present' do
        setup do
          search = Object.new
          search.stubs(:results).returns([])
          BOSSMan::Search.stubs(:web).returns(search)

          get :index, :q => 'shake it like a polaroid picture'
        end

        should respond_with(:success)
        should render_template :index
      end

      context 'without query present' do
        setup do
          get :index
        end

        should respond_with(:redirect)
        should redirect_to(:home_page) { root_path }
      end
    end
  end
end
