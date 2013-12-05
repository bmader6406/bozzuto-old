require 'test_helper'

class ApartmentFloorPlanGroupsControllerTest < ActionController::TestCase
  context "ApartmentFloorPlanGroupsController" do
    setup { @community = ApartmentCommunity.make }

    context "a GET to #index" do
      context 'with a community that is not published' do
        setup { @community.update_attribute(:published, false) }

        all_devices do
          setup do
            get :index, :apartment_community_id => @community.id
          end

          should_respond_with :not_found
        end
      end

      context 'with a community that is published' do
        desktop_device do
          setup do
            get :index, :apartment_community_id => @community.id
          end

          should_respond_with :success
          should_render_with_layout :community
          should_render_template :index
          should_assign_to(:community) { @community }
        end

        mobile_device do
          setup do
            get :index,
              :apartment_community_id => @community.id,
              :format => :mobile
          end

          should_respond_with :success
          should_render_with_layout :application
          should_render_template :index
          should_assign_to(:community) { @community }
        end
      end
    end
  end
end
