class HomeFloorPlansController < ApplicationController
  has_mobile_actions :index, :show

  layout 'application'

  before_filter :find_community, :find_home, :mobile_only

  def index
    @plans = @home.floor_plans
  end

  def show
    @plan = @home.floor_plans.find(params[:id])
  end


  private

  def find_community
    @community = HomeCommunity.find(params[:home_community_id])
  end

  def find_home
    @home = Home.find(params[:home_id])
  end

  def mobile_only
    if !mobile?
      redirect_to home_community_homes_path(@community)
    end
  end
end
