class Lead2LeaseSubmissionsController < ApplicationController
  before_filter :find_community

  layout 'community'

  def show
    @submission = Lead2LeaseSubmission.new
  end

  def create
    @submission = Lead2LeaseSubmission.new(params[:submission])

    if @submission.valid?
      Lead2LeaseMailer.deliver_submission(@community, @submission)
      flash[:email_sent] = true
      redirect_to :action => :show
    else
      render :action => :show
    end
  end


  private

  def find_community
    @community = ApartmentCommunity.find(params[:apartment_community_id])
  end
end
