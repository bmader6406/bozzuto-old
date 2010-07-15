class HomeCommunitiesController < SectionContentController
  include CommunityBehavior
  
  def index
    @communities = HomeCommunity.published.ordered_by_title.paginate(:page => params[:page])
    render :action => :index, :layout => 'application'
  end

  private

  def find_section
    @section = Section.find 'new-homes'
  end

  def find_community
    @community = HomeCommunity.published.find(params[:id])
  end
end
