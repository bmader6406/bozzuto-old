class InfoMessagesController < ApplicationController
  before_filter :assign_community

  def create
    if params[:phone_number]
      @community.send_info_message_to(params[:phone_number])
    end

    redirect_to (home? ? home_community_url(@community) : apartment_community_url(@community))
  end

  private
  def home?
    params.has_key?(:home_community_id)
  end

  def apartment?
    params.has_key?(:apartment_community_id)
  end

  def assign_community
    @community = if apartment?
      ApartmentCommunity.find(params[:apartment_community_id])
    elsif home?
      HomeCommunity.find(params[:home_community_id])
    end
  end
end
