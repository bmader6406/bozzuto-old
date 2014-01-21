require 'test_helper'

class ApartmentFloorPlansControllerTest < ActionController::TestCase
  context 'ApartmentFloorPlansController' do
    setup do
      @community = ApartmentCommunity.make
      @group     = ApartmentFloorPlanGroup.make(:studio)
    end

    context 'a GET to #index' do
      context 'with a community that is not published' do
        setup { @community.update_attribute(:published, false) }

        all_devices do
          setup do
            get :index,
              :apartment_community_id => @community.id,
              :floor_plan_group_id    => @group.id
          end

          should_respond_with :not_found
        end
      end

      context 'with a community that is published' do
        desktop_device do
          setup do
            get :index,
              :apartment_community_id => @community.id,
              :floor_plan_group_id    => @group.id
          end

          should_redirect_to('the floor plan groups page') do
            apartment_community_floor_plan_groups_path(@community)
          end
        end

        mobile_device do
          setup do
            get :index,
              :apartment_community_id => @community.id,
              :floor_plan_group_id    => @group.id
          end

          should_respond_with :success
          should_render_with_layout :application
          should_assign_to(:community) { @community }
          should_assign_to(:group) { @group }
        end
      end
    end

    context 'a GET to #show' do
      setup do
        @plan = ApartmentFloorPlan.make(
          :apartment_community => @community,
          :floor_plan_group    => @group
        )
      end

      context 'with a community that is not published' do
        setup { @community.update_attribute(:published, false) }

        all_devices do
          setup do
            get :show,
              :apartment_community_id => @community.id,
              :floor_plan_group_id    => @group.id,
              :id                     => @plan.id
          end

          should_respond_with :not_found
        end
      end

      context 'with a community that is published' do
        setup do
          @plan = ApartmentFloorPlan.make(
            :apartment_community => @community,
            :floor_plan_group    => @group
          )
        end

        desktop_device do
          setup do
            get :show,
              :apartment_community_id => @community.id,
              :floor_plan_group_id    => @group.id,
              :id                     => @plan.id
          end

          should_redirect_to('the floor plan groups page') do
            apartment_community_floor_plan_groups_path(@community)
          end
        end

        mobile_device do
          setup do
            get :show,
              :apartment_community_id => @community.id,
              :floor_plan_group_id    => @group.id,
              :id                     => @plan.id
          end

          should_respond_with :success
          should_render_with_layout :application
          should_assign_to(:community) { @community }
          should_assign_to(:group) { @group }
          should_assign_to(:plan) { @plan }
        end
      end
    end
  end
end
