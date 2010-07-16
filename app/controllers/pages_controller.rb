class PagesController < SectionContentController
  before_filter :find_page

  def show
  end


  private

  def find_page
    @page = if params[:page].any?
      @section.pages.find_by_path(current_page_path)
    else
      @section.pages.first
    end

    render_404 if @page.nil?
  end

  def current_page_path
    params[:page].join('/')
  end
  helper_method :current_page_path
end
