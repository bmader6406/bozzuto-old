class ContactSubmissionsController < SectionContentController
  has_mobile_actions :show, :create, :thank_you

  before_filter :find_topic, :only => [:show, :create]

  def show
    @submission = ContactSubmission.new(:topic => @topic)
  end

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
