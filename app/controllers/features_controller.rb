class FeaturesController < ApplicationController
  layout :detect_mobile_layout

  before_filter :find_community

  def show
  end


  private

  def find_community
    @community = if params[:apartment_community_id].present?
      ApartmentCommunity.find(params[:apartment_community_id])
    else
      HomeCommunity.find(params[:home_community_id])
    end
  end


  def detect_mobile_layout
    mobile? ? 'application' : 'community'
  end
end
