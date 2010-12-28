require 'test_helper'

class ApartmentFloorPlansControllerTest < ActionController::TestCase
  context 'ApartmentFloorPlansController' do
    setup do
      @community = ApartmentCommunity.make
      @group     = ApartmentFloorPlanGroup.studio
    end

    context 'a GET to #index' do
      context 'and not from a mobile device' do
        setup do
          get :index,
            :apartment_community_id => @community.id,
            :floor_plan_group_id => @group.id
        end

        should_redirect_to('the floor plan groups page') do
          apartment_community_floor_plan_groups_path(@community)
        end
      end

      context 'from a mobile device' do
        setup do
          set_mobile_user_agent!
          get :index,
            :apartment_community_id => @community.id,
            :floor_plan_group_id => @group.id
        end

        should_respond_with :success
        should_render_with_layout :application
        should_assign_to(:community) { @community }
        should_assign_to(:group) { @group }
      end
    end
  end
end
