class HomeCommunitiesController < SectionContentController
  layout 'application'

  def index
    @communities = HomeCommunity.published.ordered_by_title.paginate(:page => params[:page])
  end

  def show
    @community = HomeCommunity.published.find(params[:id])
  end


  private

  def find_section
    @section = Section.find 'new-homes'
  end
end
