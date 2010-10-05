module CommunityBehavior
  def features
    render :template => 'communities/features'
  end

  def neighborhood
    render :template => 'communities/neighborhood'
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
