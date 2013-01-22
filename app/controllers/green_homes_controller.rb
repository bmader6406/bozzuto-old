class GreenHomesController < SectionContentController
  before_filter :find_page

  def index
    render :layout => 'green_homes'
  end

  def show
    @community = HomeCommunity.find(params[:id])

    render :layout => 'application'
  end


  private

  def find_section
    @section = Section.find('new-homes')
  end

  def find_page
    @page = if typus_user
      @section.pages.find_by_path('green-homes')
    else
      @section.pages.published.find_by_path('green-homes')
    end

    render_404 if @page.nil?
  end

  def all_home_communities
    @all_home_communities ||= HomeCommunity.published.ordered_by_title
  end
  helper_method :all_home_communities
end
