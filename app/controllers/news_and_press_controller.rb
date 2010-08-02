class NewsAndPressController < SectionContentController
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
      @news_section.pages.find_by_path(current_page_path)
    else
      @news_section.pages.first
    end

    redirect_home if @page.nil?
  end
end
