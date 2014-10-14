class ApartmentContactSubmissionsController < ApplicationController
  has_mobile_actions :show, :create, :thank_you

  layout :detect_mobile_layout

  before_filter :find_community
  # TODO Mark for pending removal in lieu of HyLy form integration
  before_filter :build_submission, :only => [:show, :create]


  def show
  end

  # TODO Mark for pending removal in lieu of HyLy form integration
  def create
    if @community.under_construction?
      process_under_construction_lead
    else
      process_lead_2_lease_submission
    end
  end

  def thank_you
    track_millenial_media_mmurid
  end


  private

  def find_community
    @community = find_property(ApartmentCommunity, params[:apartment_community_id])
    @page      = @community.contact_page
  end

  # TODO Mark for pending removal in lieu of HyLy form integration
  def build_submission
    @submission = if @community.under_construction?
      @community.under_construction_leads.build(params[:submission])
    else
      Lead2LeaseSubmission.new(params[:submission]).tap do |submission|
        submission.lead_channel = lead_channel
      end
    end
  end

  # TODO Mark for pending removal in lieu of HyLy form integration
  def process_under_construction_lead
    if @submission.save
      flash[:apartment_contact_email] = @submission.email
      flash[:contact_form]            = 'under_construction'

      redirect_to :action => :thank_you
    else
      render :action => :show
    end
  end

  # TODO Mark for pending removal in lieu of HyLy form integration
  def process_lead_2_lease_submission
    if @submission.valid?
      Lead2LeaseMailer.submission(@community, @submission).deliver

      flash[:apartment_contact_email] = @submission.email
      flash[:contact_form]            = 'lead_2_lease'

      redirect_to :action => :thank_you
    else
      render :action => :show
    end
  end
end
