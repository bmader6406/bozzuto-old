class HomeCommunitiesController < ApplicationController
  has_mobile_actions :show

  before_filter :detect_mobile_layout
  before_filter :find_community
  before_filter :redirect_to_canonical_url

  layout :detect_mobile_layout
  
  def show
  end


  private

  def find_community
    @community = find_property(HomeCommunity, params[:id])
  end

  def redirect_to_canonical_url
    format         = request.parameters[:format]
    canonical_path = home_community_path(@community, :format => (format unless format.to_s == 'mobile'))

    if request.path != canonical_path
      redirect_to canonical_path, :status => :moved_permanently
    end
  end

  def detect_mobile_layout
    mobile? ? 'application' : 'community'
  end
end
