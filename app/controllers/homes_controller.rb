class HomesController < ApplicationController
  before_filter :find_community

  def index
  end


  private

  def find_community
    @community = HomeCommunity.find(params[:home_community_id])
  end
end
