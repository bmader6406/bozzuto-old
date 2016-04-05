class OfficeHoursController < ApplicationController
  has_mobile_actions :show

  before_filter :find_community, :mobile_only
  
  layout :detect_mobile_layout
  
  def show
    @page = @community.contact_page
  end
  
  private
  
  def find_community
    @community = apartment_community.presence || home_community
  end

  def apartment_community
    ApartmentCommunity.friendly.find(params[:apartment_community_id]) if ApartmentCommunity.friendly.exists?(params[:apartment_community_id])
  end

  def home_community
    HomeCommunity.friendly.find(params[:home_community_id])
  end

  def mobile_only
    redirect_to schedule_tour_community_url(@community) unless mobile?
  end
end
