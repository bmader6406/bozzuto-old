class PagesController < SectionContentController
  before_filter :find_page

  def show
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
