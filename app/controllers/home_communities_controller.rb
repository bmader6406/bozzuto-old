class HomeCommunitiesController < SectionContentController
  layout 'community', :except => :index

  before_filter :find_community, :except => :index

  def index
    @communities = HomeCommunity.published.ordered_by_title.paginate(:page => params[:page])
    render :action => :index, :layout => 'application'
  end

  def show
  end

  def features
    render :template => 'communities/features'
  end

  def neighborhood
    render :template => 'communities/neighborhood'
  end

  def promotions
    render :template => 'communities/promotions'
  end

  def contact
    render :template => 'communities/contact'
  end


  private

  def find_section
    @section = Section.find 'new-homes'
  end

  def find_community
    @community = HomeCommunity.published.find(params[:id])
  end
end
