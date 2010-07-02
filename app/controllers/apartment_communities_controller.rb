class ApartmentCommunitiesController < ApplicationController
  before_filter :find_community, :except => :index

  def index
    params[:search] ||= {}
    @partial_template = params[:template] || 'search'
    @search = ApartmentCommunity.search(params[:search])
    @communities = @search.all.group_by {|c| c.state.name}

    respond_to do |format|
      format.html
      format.js
    end
  end

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
    @community = ApartmentCommunity.find(params[:id])

    @recent_queue = RecentQueue.find
    @recent_queue.push(@community.id)
    @recently_viewed = @recent_queue.map { |id| ApartmentCommunity.find_by_id(id) }.compact
  end

end
