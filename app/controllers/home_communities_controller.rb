class HomeCommunitiesController < SectionContentController
  layout 'application'

  before_filter :find_community, :except => :index

  def index
    @communities = HomeCommunity.published.ordered_by_title.paginate(:page => params[:page])
  end

  def show
  end

  def features
    render :template => 'apartment_communities/features'
  end

  def neighborhood
    render :template => 'apartment_communities/neighborhood'
  end

  def promotions
    render :template => 'apartment_communities/promotions'
  end

  def contact
    render :template => 'apartment_communities/contact'
  end


  private

  def find_section
    @section = Section.find 'new-homes'
  end

  def find_community
    @community = HomeCommunity.published.find(params[:id])
  end
end
