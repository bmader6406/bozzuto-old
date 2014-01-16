class ApartmentFloorPlansController < ApplicationController
  has_mobile_actions :index, :show

  layout 'application'

  before_filter :find_community, :find_floor_plan_group, :mobile_only

  def index
    @plans = @community.floor_plans.in_group(@group).available.non_zero_min_rent
  end

  def show
    @plan = @community.floor_plans.available.non_zero_min_rent.find(params[:id])
  end


  private

  def mobile_only
    if !mobile?
      redirect_to apartment_community_floor_plan_groups_path(@community)
    end
  end

  def find_community
    @community = find_property(ApartmentCommunity, params[:apartment_community_id])
  end

  def find_floor_plan_group
    @group = ApartmentFloorPlanGroup.find(params[:floor_plan_group_id])
  end
end
