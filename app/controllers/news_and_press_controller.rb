class NewsAndPressController < SectionContentController
  def index
    @latest_news = section_news_posts.latest(10)
    @latest_press = section_press_releases.latest(10)
  end
end
