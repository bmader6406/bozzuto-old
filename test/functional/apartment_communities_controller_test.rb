require 'test_helper'

class ApartmentCommunitiesControllerTest < ActionController::TestCase
  context "ApartmentCommunitiesController" do
    setup do
      @community = ApartmentCommunity.make :latitude => rand, :longitude => rand
    end

    context 'get #index' do
      context 'for the search view' do
        setup do
          get :index
        end

        should_respond_with :success
        should_render_template :index
      end

      context 'for the map view' do
        setup do
          get :index, :template => 'map'
        end

        should_respond_with :success
        should_render_template :index
      end
    end

    context "a GET to #show" do
      browser_context do
        setup do
          get :show, :id => @community.to_param
        end

        should_respond_with :success
        should_render_with_layout :community
        should_render_template :show
        should_assign_to(:community) { @community }
      end

      mobile_context do
        setup do
          get :show,
            :id => @community.to_param,
            :format => :mobile
        end

        should_respond_with :success
        should_render_with_layout :application
        should_render_template :show
        should_assign_to(:community) { @community }
      end

      context 'for KML format' do
        setup do
          get :show,
            :id => @community.to_param,
            :format => :kml
        end

        should_respond_with :success
        should_render_without_layout
        should_render_template :show
        should_assign_to(:community) { @community }

        should 'render the KML XML' do
          assert_match /<name>#{@community.title}<\/name>/, @response.body
          assert_match /<coordinates>#{@community.latitude},#{@community.longitude},0<\/coordinates>/,
            @response.body
        end
      end
    end
  end
end
