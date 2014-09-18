require 'test_helper'

class PropertyPages::ToursControllerTest < ActionController::TestCase
  context 'a GET to #show' do
    context 'with a home community' do
      setup { @community = HomeCommunity.make }

      context 'that has a neighborhoods page' do
        setup do
          @page = PropertyToursPage.make(:property => @community)

          get :show, :home_community_id => @community.to_param
        end

        should respond_with(:success)
        should render_with_layout(:community)
        should render_template(:show)
        should assign_to(:community) { @community }
        should assign_to(:page) { @page }
      end

      context 'that does not have a neighborhoods page' do
        setup do
          get :show, :home_community_id => @community.to_param
        end

        should respond_with(:not_found)
        should assign_to(:community) { @community }
      end
    end


    context 'with an apartment community' do
      setup { @community = ApartmentCommunity.make }

      context 'that has a neighborhoods page' do
        setup do
          @page = PropertyToursPage.make(:property => @community)

          get :show, :apartment_community_id => @community.to_param
        end

        should respond_with(:success)
        should render_with_layout(:community)
        should render_template(:show)
        should assign_to(:community) { @community }
        should assign_to(:page) { @page }
      end
    
      context 'that does not have a neighborhoods page' do
        setup do
          @community = ApartmentCommunity.make

          get :show, :apartment_community_id => @community.to_param
        end

        should respond_with(:not_found)
        should assign_to(:community) { @community }
      end
    end
  end
end
