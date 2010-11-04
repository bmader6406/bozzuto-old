class SendToFriendSubmissionsController < ApplicationController
  before_filter :find_community

  layout 'community'

  def create
    if params[:email].present?
      CommunityMailer.deliver_send_to_friend(params[:email], @community)
      redirect_to thank_you_page
    else
      flash[:send_to_friend_errors] = true
      redirect_to @community
    end
  end

  def thank_you
  end


  private

  def thank_you_page
    if @community.is_a? ApartmentCommunity
      thank_you_apartment_community_send_to_friend_submissions_path(@community)
    else
      thank_you_home_community_send_to_friend_submissions_path(@community)
    end
  end

  def find_community
    @community = if params.has_key?(:apartment_community_id)
      ApartmentCommunity.find(params[:apartment_community_id])
    else
      HomeCommunity.find(params[:home_community_id])
    end
  end
end
