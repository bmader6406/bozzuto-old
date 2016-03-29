class ApartmentCommunitiesController < ApplicationController
  has_mobile_actions :show

  before_filter :find_community
  before_filter :redirect_to_canonical_url, :only => :show

  layout :detect_mobile_layout

  def show
  end

  private

  def find_community
    @community = find_property(ApartmentCommunity, params[:id])
    
    if @community.published?
      @recent_queue = RecentQueue.find
      @recent_queue.push(@community.id)
      @recently_viewed = @recent_queue.map { |id| ApartmentCommunity.find(id) }.compact
    end
  end

  def redirect_to_canonical_url
    format         = request.parameters[:format]
    canonical_path = apartment_community_path(@community, :format => (format unless format.to_s == 'mobile'))

    if request.path != canonical_path
      redirect_to canonical_path, :status => :moved_permanently
    end
  end
end
