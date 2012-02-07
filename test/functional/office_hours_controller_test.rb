require 'test_helper'

class OfficeHoursControllerTest < ActionController::TestCase
  context 'OfficeHoursController' do
    
    context 'For an Apartment' do
      setup do
        @community = ApartmentCommunity.make
        @page = PropertyContactPage.make(:property => @community)
      end

      context 'a GET to #show' do
        browser_context do
          setup do
            get :show, :apartment_community_id => @community.to_param
          end

          should_respond_with :redirect
          should_redirect_to('the contact page') {
            apartment_community_contact_url(@community)
          }
        end

        mobile_context do
          setup do
            get :show, :apartment_community_id => @community.to_param, :format => 'mobile'
          end

          should_respond_with :success
          should_render_with_layout :application
          should_render_template :show
          should_assign_to(:page){ @page }
          should_assign_to(:community){ @community }
        end
      end
    end
    
    context 'For a Home' do
      setup do
        @community = HomeCommunity.make
        @page = PropertyContactPage.make(:property => @community)
      end

      context 'a GET to #show for mobile' do
        browser_context do
          setup do
            get :show, :home_community_id => @community.to_param
          end

          should_respond_with :redirect
          should_redirect_to('the contact page') {
            home_community_contact_url(@community)
          }
        end

        mobile_context do
          setup do
            get :show, :home_community_id => @community.to_param, :format => 'mobile'
          end

          should_respond_with :success
          should_render_with_layout :application
          should_render_template :show
          should_assign_to(:page){ @page }
          should_assign_to(:community){ @community }
        end
      end
    end
  end
end
