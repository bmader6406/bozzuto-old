require 'test_helper'

class ApartmentCommunitiesControllerTest < ActionController::TestCase
  context "ApartmentCommunitiesController" do
    before do
      @community = ApartmentCommunity.make :latitude => rand, :longitude => rand
    end

    describe "GET #index" do
      context "for the search view" do
        before do
          get :index
        end

        should_respond_with :success
        should_render_template :index
      end

      context "with search params" do
        context ":in_state is present" do
          setup do
            @state = State.make
            get :index, :search => { :in_state => @state.id }
          end

          should_respond_with :success
          should_render_template :index
          should_assign_to(:geographic_filter) { @state }
        end

        context ":county_id is present" do
          setup do
            @county = County.make
            get :index, :search => { :county_id => @county.id }
          end

          should_respond_with :success
          should_render_template :index
          should_assign_to(:geographic_filter) { @county }
        end

        context ":city_id is present" do
          before do
            @city = City.make
            get :index, :search => { :city_id => @city.id }
          end

          should_respond_with :success
          should_render_template :index
          should_assign_to(:geographic_filter) { @city }
        end
      end

      context "for the map view" do
        before do
          get :index, :template => 'map'
        end

        should_respond_with :success
        should_render_template :index
      end
    end

    describe "GET #show" do
      context "with a non-canonical URL" do
        before do
          @old_slug = @community.to_param
          @community.update_attribute(:title, 'Wayne Manor')
          @canonical_slug = @community.to_param

          @canonical_slug.should_not == @old_slug

          get :show, :id => @old_slug
        end

        should_respond_with :redirect
        should_redirect_to('the canonical URL') { apartment_community_path(@canonical_slug) }
      end

      context "with an unpublished community" do
        before { @community.update_attribute(:published, false) }

        browser_context do
          before do
            get :show, :id => @community.to_param
          end

          should_respond_with :not_found
        end

        mobile_context do
          before do
            get :show, :id => @community.to_param, :format => :mobile
          end

          should_respond_with :not_found
        end
      end

      context "with a published community" do
        browser_context do
          before do
            get :show, :id => @community.to_param
          end

          should_respond_with :success
          should_render_with_layout :community
          should_render_template :show
          should_assign_to(:community) { @community }
        end

        mobile_context do
          before do
            get :show,
              :id => @community.to_param,
              :format => :mobile
          end

          should_respond_with :success
          should_render_with_layout :application
          should_render_template :show
          should_assign_to(:community) { @community }
        end
      end

      context "for KML format" do
        before do
          get :show, :id     => @community.to_param,
                     :format => :kml
        end

        should_respond_with :success
        should_render_without_layout
        should_render_template :show
        should_assign_to(:community) { @community }

        it  "renders the KML XML" do
          @response.body.should =~ /<name>#{@community.title}<\/name>/

          @response.body.should =~ /<coordinates>#{@community.latitude},#{@community.longitude},0<\/coordinates>/
        end
      end
    end
    
    describe "logged in to typus" do
      before do
        @unpublished_community = ApartmentCommunity.make(:published => false)
        @user = TypusUser.make
        login_typus_user @user
      end
      
      context "a GET to #show for an upublished community" do
        before do
          get :show, :id => @unpublished_community.to_param
        end

        should_assign_to(:community) { @unpublished_community }
        should_respond_with :success
        should_render_template :show
      end
    end

    describe "GET #rentnow" do
      before do
        get :rentnow, :id => @community.to_param
      end

      should_assign_to(:community) { @community }
      should_respond_with :success
      should_render_template :redesign
    end
  end
end
