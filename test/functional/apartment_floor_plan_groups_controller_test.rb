require 'test_helper'

class ApartmentFloorPlanGroupsControllerTest < ActionController::TestCase
  context "ApartmentFloorPlanGroupsController" do
    before do
      @community = ApartmentCommunity.make

      @floor_plan_1 = ApartmentFloorPlan.make(
        :apartment_community => @community,
        :available_units     => 10
      )

      @floor_plan_2 = ApartmentFloorPlan.make(
        :apartment_community => @community,
        :available_units     => 0
      )
    end

    describe "GET to #index" do
      context "with a community that is not published" do
        before { @community.update_attribute(:published, false) }

        all_devices do
          before do
            get :index, :apartment_community_id => @community.id
          end

          should respond_with(:not_found)
        end
      end

      context "with a community that is published" do
        desktop_device do
          before do
            get :index, :apartment_community_id => @community.id
          end

          should respond_with(:success)
          should render_with_layout(:community)
          should render_template(:index)
          should assign_to(:community) { @community }
        end

        mobile_device do
          before do
            get :index, :apartment_community_id => @community.id
          end

          should respond_with(:success)
          should render_with_layout(:application)
          should render_template(:index)
          should assign_to(:community) { @community }
        end
      end

      context "showing all floor plans" do
        before do
          get :index, :apartment_community_id => @community.id
        end

        should respond_with(:success)

        it "assigns the floor plans" do
          assigns(:filtered_floor_plans).available_floor_plans.should == [@floor_plan_1, @floor_plan_2]
        end
      end

      context "showing available floor plans" do
        before do
          get :index, :apartment_community_id => @community.id,
                      :filter => 'available'
        end

        should respond_with(:success)

        it "assigns the floor plans" do
          assigns(:filtered_floor_plans).available_floor_plans.should == [@floor_plan_1]
        end
      end
    end
  end
end
