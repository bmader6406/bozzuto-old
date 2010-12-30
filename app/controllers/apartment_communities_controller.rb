class ApartmentCommunitiesController < ApplicationController
  before_filter :find_community, :except => :index

  layout 'community', :except => :index

  def index
    params[:search] ||= {}

    @partial_template = params[:template] || 'search'
    @search = ApartmentCommunity.published.featured_order.search(params[:search])
    @geographic_filter = geographic_filter
    @communities = @search.all(:include => [:property_features, :city]).group_by {|c| c.state.name}

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
    @community = typus_user ?
      ApartmentCommunity.find(params[:id]) :
      ApartmentCommunity.published.find(params[:id])
    
    if @community.published?
      @recent_queue = RecentQueue.find
      @recent_queue.push(@community.id)
      @recently_viewed = @recent_queue.map { |id| ApartmentCommunity.find_by_id(id) }.compact
    end
  end

  def geographic_filter
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
