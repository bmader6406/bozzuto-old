class PagesController < SectionContentController
  skip_before_filter :find_section

  def show
    if params[:template]
      @page = Page.find('services')
      render :template => "pages/#{params[:template]}", :layout => 'application'
    else
      find_section
      find_page
    end
  end


  private

  def find_page
    @page = if params[:page].any?
      @section.pages.find_by_path(params[:page].join('/'))
    else
      @section.pages.first
    end

    render_404 if @page.nil?
  end
end
