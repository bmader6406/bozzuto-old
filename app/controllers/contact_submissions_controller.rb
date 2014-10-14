class ContactSubmissionsController < ApplicationController
  include Bozzuto::ContentController

  has_mobile_actions :show, :create, :thank_you

  before_filter :find_topic, :only => [:show, :create]

  def show
  # TODO Mark for pending removal in lieu of HyLy form integration
    @submission = ContactSubmission.new(:topic => @topic)
  end

  # TODO Mark for pending removal in lieu of HyLy form integration
  def create
    @submission = ContactSubmission.new(params[:contact_submission])

    if @submission.valid?
      ContactMailer.contact_form_submission(@submission).deliver
      flash[:contact_submission_email] = @submission.email
      redirect_to thank_you_contact_path
    else
      render :action => :show
    end
  end

  def thank_you
  end


  private

  def find_section
    @section = Section.about
  end

  def find_topic
    @topic = begin
      ContactTopic.find(params[:topic])
    rescue
      ContactTopic.first
    end
  end
end
