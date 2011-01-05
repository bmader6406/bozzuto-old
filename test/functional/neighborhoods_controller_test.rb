require 'test_helper'

class NeighborhoodsControllerTest < ActionController::TestCase
  context 'a GET to #show' do
    context 'with a home community' do
      setup do
        @community = HomeCommunity.make
        @page = PropertyNeighborhoodPage.make(:property => @community)
        get :show, :home_community_id => @community.to_param
      end

      should_respond_with :success
      should_render_template :show
      should_assign_to(:community) { @community }
      should_assign_to(:page) { @page }
    end

    context 'with an apartment community' do
      setup do
        @community = ApartmentCommunity.make
        @page = PropertyNeighborhoodPage.make(:property => @community)
        get :show, :apartment_community_id => @community.to_param
      end

      should_respond_with :success
      should_render_template :show
      should_assign_to(:community) { @community }
      should_assign_to(:page) { @page }
    end
    
    context 'with an apartment community without a Neighborhood page' do
      setup do
        @community = ApartmentCommunity.make
        get :show, :apartment_community_id => @community.to_param
      end

      should_respond_with :not_found
      should_assign_to(:community) { @community }
    end
  end
end
