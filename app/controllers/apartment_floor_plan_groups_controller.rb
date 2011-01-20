class ApartmentFloorPlanGroupsController < ApplicationController
  layout :detect_mobile_layout

  before_filter :find_community

  def index; end

  private

  def find_community
    @community = ApartmentCommunity.find(params[:apartment_community_id])
  end
end
