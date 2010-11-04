class HomeCommunitiesController < SectionContentController
  before_filter :find_community, :except => [:index, :map]
  before_filter :find_communities, :find_page, :only => [:index, :map]

  layout 'community', :except => [:index, :map]
  
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
      @section.pages.find 'communities'
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end

  def find_community
    @community = HomeCommunity.published.find(params[:id])
  end

  def find_communities
    @communities = HomeCommunity.published.ordered_by_title
  end
end
