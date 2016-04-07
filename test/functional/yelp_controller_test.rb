require 'test_helper'

class YelpControllerTest < ActionController::TestCase
  context "YelpController" do
    describe "GET #show" do
      before do
        @client   = mock('Yelp::Client')
        @criteria = {
          coordinates: { latitude: '40.336899', longitude: '-75.956299' },
          search:      { category_filter: 'restaurants', limit: '6', radius: '0.75' }
        }

        Yelp.stubs(:client).returns(@client)
        @client.stubs(:search_by_coordinates).with(
          @criteria[:coordinates].stringify_keys,
          @criteria[:search].stringify_keys
        ).returns('search results')
      end

      it "returns the businesses returned from Yelp based on the given params" do
        get :show, @criteria

        response.body.should == 'search results'
      end
    end
  end
end
