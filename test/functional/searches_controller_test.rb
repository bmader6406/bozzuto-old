require 'test_helper'

class SearchesControllerTest < ActionController::TestCase
  context "GET to #index" do
    all_devices do
      context "with query present and without transactions" do

        before do
          DatabaseCleaner.start
          request_matchers = [:method, :algolia_path_matcher, :algolia_host_matcher]
          VCR.use_cassette('algolia_red_keep_search', :match_requests_on => request_matchers) do
            ApartmentCommunity.algolia_clear_index!
            ApartmentCommunity.make
            ApartmentCommunity.make(title: 'The Red Keep')
            Area.make(name: 'The Red Keep')
            Award.make(title: 'The Red Keep')
            BozzutoBlogPost.make(title: 'The Red Keep')
            HomeCommunity.make(title: 'The Red Keep')
            HomeNeighborhood.make(name: 'The Red Keep')
            Leader.make(name: 'The Red Keep')
            Metro.make(name: 'The Red Keep')
            Neighborhood.make(name: 'The Red Keep')
            NewsPost.make(title: 'The Red Keep')
            Page.make(title: 'The Red Keep')
            PressRelease.make(title: 'The Red Keep')
            Project.make(title: 'The Red Keep')
            Publication.make(name: 'The Red Keep')

            get :index, :q => 'carmel'
          end
        end

        should respond_with(:success)
        should render_template :index

        teardown do
          VCR.use_cassette("algolia_teardown", :match_requests_on => [:method, :algolia_path_matcher, :algolia_host_matcher]) do
            ApartmentCommunity.algolia_clear_index!(true)
          end
          DatabaseCleaner.clean
        end
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
