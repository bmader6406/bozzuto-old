class CommunityMediaController < ApplicationController
  has_mobile_actions :index

  layout :detect_mobile_layout

  before_filter :find_community

  def index
  end


  private

  def find_community
    @community = Property.find(params[:apartment_community_id] || params[:home_community_id])
  end
end
