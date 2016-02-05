class CommunityListingEmailsController < ApplicationController
  before_filter :find_community

  layout 'community'

  def create
    if params[:email].present?
      CommunityListingMailer.single_listing(params[:email], @community).deliver_now

      save_buzz if params[:newsletter]

      redirect_to [:thank_you, @community, :email_listing], :flash => { :send_listing_email => params[:email] }
    else
      redirect_to @community, :flash => { :send_listing_errors => true }
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

  def save_buzz
    Buzz.create(
      :email        => params[:email],
      :buzzes       => '',
      :affiliations => ''
    )
  end
end
