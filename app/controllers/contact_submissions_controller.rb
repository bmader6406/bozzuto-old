class ContactSubmissionsController < ApplicationController
  def show
    @submission = ContactSubmission.new(:topic => params[:topic])
  end

  def create
    @submission = ContactSubmission.new(params[:contact_submission])

    if @submission.valid?
      redirect_to thank_you_contact_path
    else
      render :action => :show
    end
  end

  def thank_you
  end
end
