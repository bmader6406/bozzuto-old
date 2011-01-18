class HomesController < ApplicationController
  layout :detect_mobile_layout

  before_filter :find_community

  def index
  end


  private

  def find_community
    @community = HomeCommunity.find(params[:home_community_id])
  end

  def detect_mobile_layout
    mobile? ? 'application' : 'community'
  end
end
