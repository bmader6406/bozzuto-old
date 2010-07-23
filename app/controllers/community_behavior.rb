module CommunityBehavior
  def self.included(base)
    base.class_eval do
      before_filter :find_community, :except => [:index, :map]
      layout 'community', :except => [:index, :map]
    end
  end

  def show
  end

  def features
    render :template => 'communities/features'
  end

  def neighborhood
    render :template => 'communities/neighborhood'
  end

  def promotions
    render :template => 'communities/promotions'
  end

  def contact
    if request.get?
      @submission = Lead2LeaseSubmission.new
      render :template => 'communities/contact'
    else
      @submission = Lead2LeaseSubmission.new(params[:submission])
      if @submission.valid?
        Lead2LeaseMailer.deliver_submission(@community, @submission)
        flash[:email_sent] = true
        redirect_to :action => :contact
      else
        render :template => 'communities/contact'
      end
    end
  end

  def send_to_friend
    if params[:email].blank?
      flash[:error] = 'You must submit a valid email address.'
    else
      CommunityMailer.deliver_send_to_friend(params[:email], @community)
    end

    redirect_to @community
  end
end
