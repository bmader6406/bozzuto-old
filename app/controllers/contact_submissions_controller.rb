class ContactSubmissionsController < SectionContentController
  def show
    @submission = ContactSubmission.new(:topic => params[:topic])
  end

  def create
    @submission = ContactSubmission.new(params[:contact_submission])

    if @submission.valid?
      ContactMailer.deliver_contact_form_submission(@submission)
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
end
