class HomeCommunitiesController < SectionContentController
  include CommunityBehavior

  before_filter :find_communities, :only => [:index, :map]
  
  def index
    @communities = @communities.paginate(:page => params[:page])
    render :action => :index, :layout => 'application'
  end

  def map
    render :action => :map, :layout => 'application'
  end


  private

  def find_section
    @section = Section.find 'new-homes'
  end

  def find_community
    @community = HomeCommunity.published.find(params[:id])
  end

  def find_communities
    @communities = HomeCommunity.published.ordered_by_title
  end
end
