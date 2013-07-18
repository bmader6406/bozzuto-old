class CareersController < SectionContentController
  has_mobile_actions :index

  before_filter :find_section

  def index
    @page    = @section.pages.published.first
    @entries = CareersEntry.all(:limit => 4)

    if mobile?
      render 'pages/show'
    else
      render :index, :layout => 'application'
    end
  end
end
