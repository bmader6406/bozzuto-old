require 'test_helper'

class CommunitySearchesControllerTest < ActionController::TestCase
  context 'CommunitySearchesController' do
    desktop_device do
      before do
        @community = ApartmentCommunity.make
      end

      describe "GET #show" do
        context "for the search view" do
          before do
            get :show
          end

          should_respond_with :success
          should_render_template :show
        end

        context "with search params" do
          context ":in_state is present" do
            setup do
              @state = State.make

              get :show, :search => { :in_state => @state.id }
            end

            should_respond_with :success
            should_render_template :show
            should_assign_to(:geographic_filter) { @state }
          end

          context ":county_id is present" do
            setup do
              @county = County.make

              get :show, :search => { :county_id => @county.id }
            end

            should_respond_with :success
            should_render_template :show
            should_assign_to(:geographic_filter) { @county }
          end

          context ":city_id is present" do
            before do
              @city = City.make

              get :show, :search => { :city_id => @city.id }
            end

            should_respond_with :success
            should_render_template :show
            should_assign_to(:geographic_filter) { @city }
          end
        end

        context "for the map view" do
          before do
            get :show, :template => 'map'
          end

          should_respond_with :success
          should_render_template :show
        end
      end
    end

    mobile_device do
      describe "GET to #show" do
        context "with no query" do
          setup do
            get :show
          end
          
          should_respond_with :success
          should_render_template :show
        end
        
        context "with query that returns no results" do
          setup do
            get :show, :q => 'bogus'
          end
          
          should_respond_with :success
          should_render_template :show
          should_assign_to :search, :class => Bozzuto::CommunitySearch
        end
        
        context "with zip query" do
          setup do
            ApartmentCommunity.make(:zip_code => '22301')
            HomeCommunity.make(:zip_code => '22301-5601')
            
            get :show, :q => '22301'
          end
          
          should_respond_with :success
          should_render_template :results
          should_assign_to :search, :class => Bozzuto::CommunitySearch
        end
        
        context "with name query" do
          setup do
            ApartmentCommunity.make(:title => 'The Metropolitan')
            HomeCommunity.make(:title => 'Metropolitan Village')
            
            get :show, :q => 'Metro'
          end
          
          should_respond_with :success
          should_render_template :results
          should_assign_to :search, :class => Bozzuto::CommunitySearch
        end
        
        context "with city query" do
          setup do
            @city = City.make(:name => 'Bethesda')
            ApartmentCommunity.make(:title => 'Upstairs at Bethesda Row', :city => @city)
            HomeCommunity.make(:title => 'Utopia Village', :city => @city)
            
            get :show, :q => 'Bethesda'
          end
          
          should_respond_with :success
          should_render_template :results
          should_assign_to :search, :class => Bozzuto::CommunitySearch
        end

        context "with name query for unpublished community" do
          setup do
            ApartmentCommunity.make(:unpublished, :title => 'Swing City')

            get :show, :q => 'Swing'
          end

          should_respond_with :success
          should_render_template :show
          should_assign_to :search, :class => Bozzuto::CommunitySearch

          it "returns no results" do
            @controller.instance_variable_get('@search').results.should == { :title => [], :city => [] }
          end
        end
      end
    end
  end
end
