class OfficeHoursController < ApplicationController
  before_filter :find_community
  
  layout :detect_mobile_layout
  
  def show
    @page = @community.contact_page
  end
  
  private
  
  def find_community
    @community = Property.find(params[:apartment_community_id] || params[:home_community_id])
  end
  
  def detect_mobile_layout
    mobile? ? 'application' : 'community'
  end
end
