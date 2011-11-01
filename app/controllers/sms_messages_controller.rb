class SmsMessagesController < ApplicationController
  has_mobile_actions :new, :create, :thank_you

  before_filter :find_community

  layout :detect_mobile_layout
  
  def new; end

  def create
    respond_to do |format|
      format.html {
        if params[:phone_number].present?
          @community.send_info_message_to(params[:phone_number])
          redirect_to thank_you_page
        else
          flash[:send_to_phone_errors] = true
          redirect_to @community
        end
      }
      format.mobile {
        if params[:phone_number].present?
          @community.send_info_message_to(params[:phone_number])
          render :thank_you
        else
          render :new
        end
      }
    end
  end

  def thank_you
  end


  private

  def home?
    params.has_key?(:home_community_id)
  end

  def apartment?
    params.has_key?(:apartment_community_id)
  end

  def thank_you_page
    if apartment?
      thank_you_apartment_community_sms_message_path(@community)
    else
      thank_you_home_community_sms_message_path(@community)
    end
  end

  def find_community
    @community = if apartment?
      ApartmentCommunity.find(params[:apartment_community_id])
    elsif home?
      HomeCommunity.find(params[:home_community_id])
    end
  end
end
