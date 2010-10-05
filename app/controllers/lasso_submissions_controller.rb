class LassoSubmissionsController < ApplicationController
  before_filter :find_community

  layout 'community'

  def show
  end

  def thank_you
  end


  private

  def find_community
    @community = HomeCommunity.find(params[:home_community_id])
  end
end
