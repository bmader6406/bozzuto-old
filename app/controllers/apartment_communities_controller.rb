class ApartmentCommunitiesController < ApplicationController
  has_mobile_actions :index, :show

  before_filter :find_community, :except => :index
  before_filter :redirect_to_canonical_url, :only => :show

  layout :detect_mobile_layout

  def index
    params[:search] ||= {}

    @partial_template = params[:template] || 'search'

    @search = ApartmentCommunity.published.featured_order.search(params[:search])

    @communities = @search.all(:include => [:property_features, :city]).group_by { |c| c.state.name }

    @ordered_states = State.all.sort { |a, b|
      (@communities[b.name].try(:count) || 0) <=> (@communities[a.name].try(:count) || 0)
    }

    respond_to do |format|
      format.html do
        render :action => :index, :layout => 'application'
      end
      format.js
    end
  end

  def show
  end


  private

  def find_community
    @community = find_property(ApartmentCommunity, params[:id])
    
    if @community.published?
      @recent_queue = RecentQueue.find
      @recent_queue.push(@community.id)
      @recently_viewed = @recent_queue.map { |id| ApartmentCommunity.find_by_id(id) }.compact
    end
  end

  def redirect_to_canonical_url
    format         = request.parameters[:format]
    canonical_path = apartment_community_path(@community, :format => format)

    if request.path != canonical_path
      redirect_to canonical_path, :status => :moved_permanently
    end
  end

  def geographic_filter
    @geographic_filter ||= begin
      search = params[:search]

      if search[:in_state].present?
        State.find_by_id(search[:in_state])
      elsif search[:county_id].present?
        County.find_by_id(search[:county_id])
      elsif search[:city_id].present?
        City.find_by_id(search[:city_id])
      end
    end
  end
  helper_method :geographic_filter

end
