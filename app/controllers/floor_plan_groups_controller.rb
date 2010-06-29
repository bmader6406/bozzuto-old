class FloorPlanGroupsController < ApplicationController
  before_filter :find_community

  def index
    @groups = FloorPlanGroup.all
  end


  private

  def find_community
    @community = ApartmentCommunity.find(params[:apartment_community_id])
  end
end
