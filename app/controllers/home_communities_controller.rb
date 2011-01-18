class HomeCommunitiesController < SectionContentController
  before_filter :find_community, :except => [:index, :map]
  before_filter :find_communities, :find_page, :only => [:index, :map]

  layout :detect_mobile_layout
  
  def index
    @communities = @communities.paginate(:page => params[:page])
    render :action => :index, :layout => 'application'
  end

  def show
  end

  def map
    render :action => :map, :layout => 'application'
  end

  def contact
  end


  private

  def find_section
    @section = Section.find 'new-homes'
  end

  def find_page
    @page = begin
      @section.pages.published.find 'communities'
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end

  def find_community
    @community = typus_user ?
      HomeCommunity.find(params[:id]) :
      HomeCommunity.published.find(params[:id])
  end

  def find_communities
    @communities = HomeCommunity.published.ordered_by_title
  end

  def detect_mobile_layout
    mobile? ? 'application' : 'community'
  end
end
