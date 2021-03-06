require 'test_helper'

class SearchesControllerTest < ActionController::TestCase
  context "GET to #index" do
    all_devices do
      context "with query present and without transactions" do

        before do
          DatabaseCleaner.start
        end

        context 'performing a basic search' do
          before do
            request_matchers = [:method, :algolia_path_matcher, :algolia_host_matcher]
            VCR.use_cassette('algolia_red_keep_search', match_requests_on: request_matchers) do
              ApartmentCommunity.algolia_clear_index!
              section = Section.make(:about)
              ApartmentCommunity.make
              ApartmentCommunity.make(title: 'The Red Keep')
              Area.make(name: 'The Red Keep')
              Award.make(title: 'The Red Keep', sections: [section])
              BozzutoBlogPost.make(title: 'The Red Keep')
              HomeCommunity.make(title: 'The Red Keep')
              HomeNeighborhood.make(name: 'The Red Keep')
              Leader.make(name: 'The Red Keep')
              Metro.make(name: 'The Red Keep')
              Neighborhood.make(name: 'The Red Keep')
              NewsPost.make(title: 'The Red Keep', sections: [section])
              Page.make(title: 'The Red Keep')
              PressRelease.make(title: 'The Red Keep', sections: [section])
              Project.make(title: 'The Red Keep', section: section)

              get :index, q: 'red keep'
            end
          end

          should respond_with(:success)
          should render_template :index
        end

        context 'with tagged result' do
          before do
            request_matchers = [:method, :algolia_path_matcher, :algolia_host_matcher]
            VCR.use_cassette('algolia_tagged_search', match_requests_on: request_matchers) do
              ApartmentCommunity.algolia_clear_index!
              ApartmentCommunity.make
              @community = ApartmentCommunity.make(title: 'The Red Keep', tag_list: ['pay rent'])
              HomeCommunity.make(title: 'The Red Keep')
              HomeNeighborhood.make(name: 'The Red Keep')
              Neighborhood.make(name: 'The Red Keep')

              get :index, q: 'red keep pay rent'
            end
          end

          should respond_with(:success)
          should render_template :index

          it "has only one result" do
            assigns(:search_results).should == [@community]
          end
        end

        teardown do
          VCR.use_cassette("algolia_teardown", match_requests_on: [:method, :algolia_path_matcher, :algolia_host_matcher]) do
            ApartmentCommunity.algolia_clear_index!(true)
          end
          DatabaseCleaner.clean
        end
      end

      context 'with query present and a SearchResultProxy' do
        before do
          VCR.use_cassette('search_proxy_good') do
            SearchResultProxy.create(query: 'Something Juicy', url: 'https://google.com/')
          end

          get :index, q: 'something JUICY'
        end

        should respond_with(:redirect)
        should redirect_to('the supplied URL') { "https://google.com/" }
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
