class PromosController < ApplicationController
  layout 'application'

  before_filter :find_community, :find_promo, :mobile_only

  def index
  end


  private

  def find_community
    @community = if params[:apartment_community_id].present?
      ApartmentCommunity.find(params[:apartment_community_id])
    else
      HomeCommunity.find(params[:home_community_id])
    end
  end

  def find_promo
    if @community.has_active_promo?
      @promo = @community.promo
    else
      redirect_to @community
    end
  end

  def mobile_only
    redirect_to @community if !mobile?
  end
end
