class FloorPlanGroupsController < ApplicationController
  before_filter :find_community

  def index
    @groups = @community.floor_plan_groups(:include => :floor_plans)
  end


  private

  def find_community
    @community = ApartmentCommunity.find(params[:apartment_community_id])
  end
end
