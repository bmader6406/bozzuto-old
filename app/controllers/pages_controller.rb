class PagesController < SectionContentController
  before_filter :find_page

  def show
  end

  private

  def find_page
    @page = if params[:page].any?
      typus_user ?
        @section.pages.find_by_path(current_page_path) :
        @section.pages.published.find_by_path(current_page_path)
    else
      @section.pages.published.first
    end

    render_404 if @page.nil?
  end
end
