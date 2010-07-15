class ApartmentCommunitiesController < ApplicationController
  include CommunityBehavior

  def index
    params[:search] ||= {}
    @partial_template = params[:template] || 'search'
    @search = ApartmentCommunity.published.search(params[:search])
    @communities = @search.all.group_by {|c| c.state.name}

    respond_to do |format|
      format.html do
        render :action => :index, :layout => 'application'
      end
      format.js
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

  private

  def find_community
    @community = ApartmentCommunity.published.find(params[:id])

    @recent_queue = RecentQueue.find
    @recent_queue.push(@community.id)
    @recently_viewed = @recent_queue.map { |id| ApartmentCommunity.find_by_id(id) }.compact
  end

end
