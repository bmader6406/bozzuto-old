class CareersController < SectionContentController
  layout 'application'

  before_filter :find_section

  def index
    @page = @section.pages.published.first
  end
end
