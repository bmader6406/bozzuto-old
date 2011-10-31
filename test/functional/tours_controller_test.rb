require 'test_helper'

class ToursControllerTest < ActionController::TestCase
  context 'a GET to #show' do
    context 'with a home community' do
      setup { @community = HomeCommunity.make }

      context 'that has a neighborhoods page' do
        setup do
          @page = PropertyToursPage.make(:property => @community)

          get :show, :home_community_id => @community.to_param
        end

        should_respond_with :success
        should_render_with_layout :community
        should_render_template :show
        should_assign_to(:community) { @community }
        should_assign_to(:page) { @page }
      end

      context 'that does not have a neighborhoods page' do
        setup do
          get :show, :home_community_id => @community.to_param
        end

        should_respond_with :not_found
        should_assign_to(:community) { @community }
      end
    end


    context 'with an apartment community' do
      setup { @community = ApartmentCommunity.make }

      context 'that has a neighborhoods page' do
        setup do
          @page = PropertyToursPage.make(:property => @community)

          get :show, :apartment_community_id => @community.to_param
        end

        should_respond_with :success
        should_render_with_layout :community
        should_render_template :show
        should_assign_to(:community) { @community }
        should_assign_to(:page) { @page }
      end
    
      context 'that does not have a neighborhoods page' do
        setup do
          @community = ApartmentCommunity.make

          get :show, :apartment_community_id => @community.to_param
        end

        should_respond_with :not_found
        should_assign_to(:community) { @community }
      end
    end
  end
end
