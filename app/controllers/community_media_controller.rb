class CommunityMediaController < ApplicationController
  has_mobile_actions :index

  layout :detect_mobile_layout

  before_filter :find_community

  def index
  end


  private

  def find_community
    klass, community_id = if params[:apartment_community_id].present?
      [ApartmentCommunity, params[:apartment_community_id]]
    else
      [HomeCommunity, params[:home_community_id]]
    end

    @community = find_property(klass, community_id)
  end
end
