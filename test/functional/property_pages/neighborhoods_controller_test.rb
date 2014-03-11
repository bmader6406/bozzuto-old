require 'test_helper'

class PropertyPages::NeighborhoodsControllerTest < ActionController::TestCase
  context 'a GET to #show' do
    context 'with a home community' do
      setup { @community = HomeCommunity.make }

      context 'that is not published' do
        setup { @community.update_attribute(:published, false) }

        desktop_device do
          setup do
            get :show, :home_community_id => @community.to_param
          end

          should_respond_with :not_found
        end

        mobile_device do
          setup do
            get :show, :home_community_id => @community.to_param
          end

          should_respond_with :not_found
        end
      end

      context 'that has a neighborhoods page' do
        setup do
          @page = PropertyNeighborhoodPage.make(:property => @community)
        end

        desktop_device do
          setup do
            get :show, :home_community_id => @community.to_param
          end

          should_respond_with :success
          should_render_with_layout :community
          should_render_template :show
          should_assign_to(:community) { @community }
          should_assign_to(:page) { @page }
        end

        mobile_device do
          setup do
            get :show, :home_community_id => @community.to_param
          end

          should_respond_with :success
          should_render_with_layout :application
          should_render_template :show
          should_assign_to(:community) { @community }
          should_assign_to(:page) { @page }
        end
      end

      context 'that does not have a neighborhoods page' do
        desktop_device do
          setup do
            get :show, :home_community_id => @community.to_param
          end

          should_respond_with :not_found
          should_assign_to(:community) { @community }
        end

        mobile_device do
          setup do
            get :show, :home_community_id => @community.to_param
          end

          should_respond_with :not_found
          should_assign_to(:community) { @community }
        end
      end
    end


    context 'with an apartment community' do
      setup { @community = ApartmentCommunity.make }

      context 'that is not published' do
        setup { @community.update_attribute(:published, false) }

        desktop_device do
          setup do
            get :show, :apartment_community_id => @community.to_param
          end

          should_respond_with :not_found
        end

        mobile_device do
          setup do
            get :show, :apartment_community_id => @community.to_param
          end

          should_respond_with :not_found
        end
      end

      context 'that has a neighborhoods page' do
        setup do
          @page = PropertyNeighborhoodPage.make(:property => @community)
        end

        desktop_device do
          setup do
            get :show, :apartment_community_id => @community.to_param
          end

          should_respond_with :success
          should_render_with_layout :community
          should_render_template :show
          should_assign_to(:community) { @community }
          should_assign_to(:page) { @page }
        end

        mobile_device do
          setup do
            get :show, :apartment_community_id => @community.to_param
          end

          should_respond_with :success
          should_render_with_layout :application
          should_render_template :show
          should_assign_to(:community) { @community }
          should_assign_to(:page) { @page }
        end
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
