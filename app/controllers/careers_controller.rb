class CareersController < SectionContentController
  before_filter :find_section

  def index
    @page    = @section.pages.published.first
    @entries = CareersEntry.all(:limit => 4)

    render :index, :layout => 'application'
  end
end
