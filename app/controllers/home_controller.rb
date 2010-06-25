class HomeController < ApplicationController
  def index
    @latest_news = NewsPost.published.latest(1).first
  end
end
