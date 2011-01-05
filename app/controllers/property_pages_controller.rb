class PropertyPagesController < ApplicationController
  class_attribute :property_page_type
  layout 'community'

  before_filter :find_community

  def show
    @page = @community.send("#{property_page_type}_page")
    if @page.blank?
      render_404
    end
  end


  private

  def find_community
    @community = if params[:apartment_community_id].present?
      ApartmentCommunity.find(params[:apartment_community_id])
    else
      HomeCommunity.find(params[:home_community_id])
    end
  end
end
