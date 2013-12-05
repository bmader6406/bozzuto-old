require 'test_helper'

class CommunitySearchesControllerTest < ActionController::TestCase
  context 'CommunitySearchesController' do
    desktop_device do
      context 'get to #show' do
        desktop_device do
          setup { get :show }

          should_redirect_to('the apartment communities page') { apartment_communities_url}
        end
      end
    end

    mobile_device do
      context 'get #show with no query' do
        setup do
          get :show
        end
        
        should_respond_with :success
        should_render_template :show
      end
      
      context 'get #show with query that returns no results' do
        setup do
          get :show, :q => 'bogus'
        end
        
        should_respond_with :success
        should_render_template :show
        should_assign_to :search, :class => Bozzuto::CommunitySearch
      end
      
      context 'get #show with zip query' do
        setup do
          ApartmentCommunity.make(:zip_code => '22301')
          HomeCommunity.make(:zip_code => '22301-5601')
          
          get :show, :q => '22301'
        end
        
        should_respond_with :success
        should_render_template :results
        should_assign_to :search, :class => Bozzuto::CommunitySearch
      end
      
      context 'get #show with name query' do
        setup do
          ApartmentCommunity.make(:title => 'The Metropolitan')
          HomeCommunity.make(:title => 'Metropolitan Village')
          
          get :show, :q => 'Metro'
        end
        
        should_respond_with :success
        should_render_template :results
        should_assign_to :search, :class => Bozzuto::CommunitySearch
      end
      
      context 'get #show with city query' do
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

      context 'get #show with name query for unpublished community' do
        setup do
          ApartmentCommunity.make(:unpublished, :title => 'Swing City')
          get :show, :q => 'Swing'
        end

        should_respond_with :success
        should_render_template :show
        should_assign_to :search, :class => Bozzuto::CommunitySearch

        should 'return no results' do
          assert_equal({ :title => [], :city => [] },
            @controller.instance_variable_get('@search').results)
        end
      end
    end
  end
end
