require 'test_helper'

class SearchesControllerTest < ActionController::TestCase
  context "GET to #index" do
    all_devices do
      context "with query present" do
        before do
          VCR.use_cassette('boss_search_carmel', :match_requests_on => [:method, :host, :path]) do
            get :index, :q => 'carmel'
          end
        end

        should respond_with(:success)
        should render_template :index
      end

      context "without query present" do
        before do
          get :index
        end

        should respond_with(:redirect)
        should redirect_to(:home_page) { root_path }
      end
    end
  end
end
