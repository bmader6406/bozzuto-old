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

  def build_submission
    @submission = if @community.under_construction?
      @community.under_construction_leads.build(params[:submission])
    end
  end

  def process_under_construction_lead
    if @submission.save
      flash[:apartment_contact_email] = @submission.email
      flash[:contact_form]            = 'under_construction'

      redirect_to :action => :thank_you
    else
      render :action => :show
    end
  end
end
