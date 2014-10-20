class ApartmentContactSubmissionsController < ApplicationController
  has_mobile_actions :show, :create, :thank_you

  layout :detect_mobile_layout

  before_filter :find_community

  def show
  end

  def thank_you
    track_millenial_media_mmurid
  end


  private

  def find_community
    @community = find_property(ApartmentCommunity, params[:apartment_community_id])
    @page      = @community.contact_page
  end
end
