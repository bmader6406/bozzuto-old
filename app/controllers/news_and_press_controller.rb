class NewsAndPressController < SectionContentController
  browser_only!

  def index
    @latest_news = section_news_posts.latest(10)
    @latest_press = section_press_releases.latest(10)
  end

  def show
    find_page
  end


  private

  def find_page
    @page = if params[:page].any?
      typus_user ?
        @news_section.pages.find_by_path(current_page_path) :
        @news_section.pages.published.find_by_path(current_page_path)
    else
      @news_section.pages.published.first
    end

    render_404 if @page.nil?
  end
end
