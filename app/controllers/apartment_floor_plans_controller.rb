class ApartmentFloorPlansController < ApplicationController
  layout 'application'

  before_filter :find_community, :find_floor_plan_group, :mobile_only

  def index
    @plans = @community.floor_plans.in_group(@group)
  end

  def show
    @plan = ApartmentFloorPlan.find(params[:id])
  end


  private


  def mobile_only
    if !mobile?
      redirect_to apartment_community_floor_plan_groups_path(@community)
    end
  end

  def find_community
    @community = ApartmentCommunity.find(params[:apartment_community_id])
  end

  def find_floor_plan_group
    @group = ApartmentFloorPlanGroup.find(params[:floor_plan_group_id])
  end
end
