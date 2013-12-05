class HomeCommunitiesController < SectionContentController
  has_mobile_actions :index, :show, :map, :contact

  before_filter :find_community, :except => [:index, :map]
  before_filter :find_communities, :find_page, :only => [:index, :map]
  before_filter :redirect_to_canonical_url, :only => :show

  layout :detect_mobile_layout
  
  def index
    @communities = @communities.paginate(:page => params[:page])

    respond_to do |format|
      format.html { render :action => :index, :layout => 'application' }
      format.mobile
    end
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
    @community = find_property(HomeCommunity, params[:id])
  end

  def find_communities
    @communities = HomeCommunity.published.ordered_by_title
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
