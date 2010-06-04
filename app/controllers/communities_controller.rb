class CommunitiesController < ApplicationController
  before_filter :find_community

  def show
  end

  def features
  end

  def neighborhood
  end

  def promotions
  end

  def contact
  end

  def send_to_friend
    if params[:email].blank?
      flash[:error] = 'You must submit a valid email address.'
    else
      CommunityMailer.deliver_send_to_friend(params[:email], @community)
    end

    redirect_to @community
  end

  private

    def find_community
      @community = Community.find(params[:id])
    end
end
