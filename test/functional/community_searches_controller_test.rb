require 'test_helper'

class CommunitySearchesControllerTest < ActionController::TestCase
  context 'CommunitySearchesController' do
    context 'get to #show' do
      browser_context do
        setup { get :show }

        should_redirect_to('the apartment communities page') { apartment_communities_url}
      end
    end

    context 'get #show with no query' do
      setup do
        get :show, :format => :mobile
      end
      
      should_respond_with :success
      should_render_template :show
    end
    
    context 'get #show with query that returns no results' do
      setup do
        get :show, :format => :mobile, :q => 'bogus'
      end
      
      should_respond_with :success
      should_render_template :show
      should_assign_to :search, :class => Bozzuto::CommunitySearch
    end
    
    context 'get #show with zip query' do
      setup do
        ApartmentCommunity.make(:zip_code => '22301')
        HomeCommunity.make(:zip_code => '22301-5601')
        
        get :show, :format => :mobile, :q => '22301'
      end
      
      should_respond_with :success
      should_render_template :results
      should_assign_to :search, :class => Bozzuto::CommunitySearch
    end
    
    context 'get #show with name query' do
      setup do
        ApartmentCommunity.make(:title => 'The Metropolitan')
        HomeCommunity.make(:title => 'Metropolitan Village')
        
        get :show, :format => :mobile, :q => 'Metro'
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
        
        get :show, :format => :mobile, :q => 'Bethesda'
      end
      
      should_respond_with :success
      should_render_template :results
      should_assign_to :search, :class => Bozzuto::CommunitySearch
    end
  end
end
