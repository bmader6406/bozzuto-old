class ContactSubmissionsController < ApplicationController
  def show
    @submission = ContactSubmission.new(:topic => params[:topic])
  end

  def create
    @submission = ContactSubmission.new(params[:contact_submission])

    if @submission.valid?
      redirect_to 'http://google.com'
    else
      render :action => :show
    end
  end
end
