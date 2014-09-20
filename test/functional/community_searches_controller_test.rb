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

          should respond_with(:success)
          should render_template(:show)
        end

        context "with search params" do
          context "in the old format" do
            before do
              get :show, :search => { :city_id => 123, :county_id => 456 }
            end

            should respond_with(:success)

            it "converts them to the new format" do
              params = @controller.params

              params[:search][:city_id].should == nil
              params[:search][:city_id_eq].should == 123

              params[:search][:county_id].should == nil
              params[:search][:county_id_eq].should == 456
            end
          end

          context ":in_state is present" do
            setup do
              @state = State.make

              get :show, :search => { :in_state => @state.id }
            end

            should respond_with(:success)
            should render_template(:show)
            should assign_to(:geographic_filter) { @state }
          end

          context ":county_id is present" do
            setup do
              @county = County.make

              get :show, :search => { :county_id_eq => @county.id }
            end

            should respond_with(:success)
            should render_template(:show)
            should assign_to(:geographic_filter) { @county }
          end

          context ":city_id is present" do
            before do
              @city = City.make

              get :show, :search => { :city_id_eq => @city.id }
            end

            should respond_with(:success)
            should render_template(:show)
            should assign_to(:geographic_filter) { @city }
          end
        end

        context "for the map view" do
          before do
            get :show, :template => 'map'
          end

          should respond_with(:success)
          should render_template(:show)
        end
      end
    end

    mobile_device do
      describe "GET to #show" do
        context "with no query" do
          setup do
            get :show
          end
          
          should respond_with(:success)
          should render_template(:show)
        end
        
        context "with query that returns no results" do
          setup do
            get :show, :q => 'bogus'
          end
          
          should respond_with(:success)
          should render_template(:show)
          should assign_to(:search)
        end
        
        context "with zip query" do
          setup do
            ApartmentCommunity.make(:zip_code => '22301')
            HomeCommunity.make(:zip_code => '22301-5601')
            
            get :show, :q => '22301'
          end
          
          should respond_with(:success)
          should render_template(:results)
          should assign_to(:search)
        end
        
        context "with name query" do
          setup do
            ApartmentCommunity.make(:title => 'The Metropolitan')
            HomeCommunity.make(:title => 'Metropolitan Village')
            
            get :show, :q => 'Metro'
          end
          
          should respond_with(:success)
          should render_template(:results)
          should assign_to(:search)
        end
        
        context "with city query" do
          setup do
            @city = City.make(:name => 'Bethesda')
            ApartmentCommunity.make(:title => 'Upstairs at Bethesda Row', :city => @city)
            HomeCommunity.make(:title => 'Utopia Village', :city => @city)
            
            get :show, :q => 'Bethesda'
          end
          
          should respond_with(:success)
          should render_template(:results)
          should assign_to(:search)
        end

        context "with name query for unpublished community" do
          setup do
            ApartmentCommunity.make(:unpublished, :title => 'Swing City')

            get :show, :q => 'Swing'
          end

          should respond_with(:success)
          should render_template(:show)
          should assign_to(:search)

          it "returns no results" do
            @controller.instance_variable_get('@search').results.should == { :title => [], :city => [] }
          end
        end
      end
    end
  end
end
