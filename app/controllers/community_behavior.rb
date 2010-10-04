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

  def send_to_friend
    if params[:email].blank?
      flash[:error] = 'You must submit a valid email address.'
    else
      CommunityMailer.deliver_send_to_friend(params[:email], @community)
    end

    redirect_to @community
  end
end
