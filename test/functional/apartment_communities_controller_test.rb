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

      context 'with search params' do
        context 'and :in_state is present' do
          setup do
            @state = State.make
            get :index, :search => { :in_state => @state.id }
          end

          should_respond_with :success
          should_render_template :index
          should_assign_to(:geographic_filter) { @state }
        end

        context 'and :county_id is present' do
          setup do
            @county = County.make
            get :index, :search => { :county_id => @county.id }
          end

          should_respond_with :success
          should_render_template :index
          should_assign_to(:geographic_filter) { @county }
        end

        context 'and :city_id is present' do
          setup do
            @city = City.make
            get :index, :search => { :city_id => @city.id }
          end

          should_respond_with :success
          should_render_template :index
          should_assign_to(:geographic_filter) { @city }
        end
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
    
    context 'logged in to typus' do
      setup do
        @unpublished_community = ApartmentCommunity.make(:published => false)
        @user = TypusUser.make
        login_typus_user @user
      end
      
      context "a GET to #show for an upublished community" do
        setup do
          get :show, :id => @unpublished_community.to_param
        end

        should_assign_to(:community) { @unpublished_community }
        should_respond_with :success
        should_render_template :show
      end
    end
  end
end
