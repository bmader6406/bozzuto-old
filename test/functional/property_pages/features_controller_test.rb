require 'test_helper'

class PropertyPages::FeaturesControllerTest < ActionController::TestCase
  context 'a GET to #show' do
    context 'with a home community' do
      setup { @community = HomeCommunity.make }

      context 'that has a page' do
        setup do
          @page = PropertyFeaturesPage.make(:property => @community)
        end

        desktop_device do
          setup do
            get :show, :home_community_id => @community.to_param
          end

          should respond_with(:success)
          should render_with_layout(:community)
          should render_template(:show)
          should assign_to(:community) { @community }
          should assign_to(:page) { @page }
        end

        mobile_device do
          setup do
            get :show, :home_community_id => @community.to_param
          end

          should respond_with(:success)
          should render_with_layout(:application)
          should render_template(:show)
          should assign_to(:community) { @community }
          should assign_to(:page) { @page }
        end
      end

      context 'that does not have a page' do
        all_devices do
          setup do
            get :show, :home_community_id => @community.to_param
          end

          should respond_with(:not_found)
          should assign_to(:community) { @community }
        end
      end
    end

    context 'with an apartment community' do
      setup { @community = ApartmentCommunity.make }

      context 'that has a page' do
        setup do
          @page  = PropertyFeaturesPage.make(:property => @community)
        end

        desktop_device do
          setup do
            get :show, :apartment_community_id => @community.to_param
          end

          should respond_with(:success)
          should render_with_layout(:community)
          should render_template(:show)
          should assign_to(:community) { @community }
          should assign_to(:page) { @page }
        end

        mobile_device do
          setup do
            get :show, :apartment_community_id => @community.to_param
          end

          should respond_with(:success)
          should render_with_layout(:application)
          should render_template(:show)
          should assign_to(:community) { @community }
          should assign_to(:page) { @page }
        end
      end
      
      context 'that does not have a page' do
        desktop_device do
          setup do
            get :show, :apartment_community_id => @community.to_param
          end

          should respond_with(:not_found)
          should assign_to(:community) { @community }
        end

        mobile_device do
          setup do
            get :show, :apartment_community_id => @community.to_param
          end

          should respond_with(:not_found)
          should assign_to(:community) { @community }
        end
      end
    end
  end
end
