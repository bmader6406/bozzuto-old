class NewsAndPressController < SectionContentController
  before_filter :find_section, :find_news_section

  def index
    @latest_news = section_news_posts.latest(10)
    @latest_press = section_press_releases.latest(10)
  end


  private

  def find_news_section
    @news_section = if @section.about?
      Section.news_and_press
    else
      nil
    end
  end
end
