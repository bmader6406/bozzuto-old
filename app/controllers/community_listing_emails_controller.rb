class CommunityListingEmailsController < ApplicationController
  before_filter :find_community

  layout 'community'

  def create
    if params[:email].present?
      CommunityListingMailer.deliver_single_listing(params[:email], @community)

      flash[:send_to_friend_email] = params[:email]

      redirect_to [:thank_you, @community, :email_listing]
    else
      flash[:send_to_friend_errors] = true

      redirect_to @community
    end
  end

  def thank_you
  end


  private

  def find_community
    @community = if params.has_key?(:apartment_community_id)
      ApartmentCommunity.find(params[:apartment_community_id])
    else
      HomeCommunity.find(params[:home_community_id])
    end
  end
end
