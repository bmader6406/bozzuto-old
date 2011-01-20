class Lead2LeaseSubmissionsController < ApplicationController
  before_filter :find_community

  layout :detect_mobile_layout

  def show
    @submission = Lead2LeaseSubmission.new
  end

  def create
    @submission = Lead2LeaseSubmission.new(params[:submission])

    if @submission.valid?
      Lead2LeaseMailer.deliver_submission(@community, @submission)
      flash[:email_sent] = true
      flash[:lead_2_lease_email] = @submission.email
      redirect_to :action => :thank_you
    else
      render :action => :show
    end
  end

  def thank_you
  end


  private

  def find_community
    @community = ApartmentCommunity.find(params[:apartment_community_id])
    @page = @community.contact_page
  end
end
