class ApartmentContactSubmissionsController < ApplicationController
  has_mobile_actions :show, :create, :thank_you

  layout :detect_mobile_layout

  before_filter :find_community
  before_filter :build_submission, :only => [:show, :create]


  def show
  end

  def create
    if @community.under_construction?
      process_under_construction_lead
    else
      process_lead_2_lease_submission
    end
  end

  def thank_you
  end


  private

  def find_community
    @community = find_property(ApartmentCommunity, params[:apartment_community_id])
    @page      = @community.contact_page
  end

  def build_submission
    @submission = if @community.under_construction?
      @community.under_construction_leads.build(params[:submission])
    else
      Lead2LeaseSubmission.new(params[:submission])
    end
  end

  def process_under_construction_lead
    if @submission.save
      flash[:apartment_contact_email] = @submission.email

      redirect_to :action => :thank_you
    else
      render :action => :show
    end
  end

  def process_lead_2_lease_submission
    if @submission.valid?
      Lead2LeaseMailer.deliver_submission(@community, @submission)

      flash[:apartment_contact_email] = @submission.email

      redirect_to :action => :thank_you
    else
      render :action => :show
    end
  end
end