class HomeController < ApplicationController
  def index
    @latest_news = NewsPost.published.latest(1).first
    @property = PropertyMiniSlideshow.first.try(:property)
  end
end
