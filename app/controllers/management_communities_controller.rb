class ManagementCommunitiesController < SectionContentController
  before_filter :find_page

  def index
    @communities = ApartmentCommunity.published.ordered_by_title
  end


  private

  def find_page
    @page = begin
      @section.pages.published.find 'communities'
    rescue
      nil
    end
  end
end
