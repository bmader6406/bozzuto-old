class CareersController < SectionContentController
  has_mobile_actions :index

  before_filter :find_section

  def index
    @page    = @section.pages.published.first
    @entries = CareersEntry.all(:limit => 4)

    respond_to do |wants|
      wants.html   { render :index, :layout => 'application' }
      wants.mobile { render 'pages/show' }
    end
  end
end
