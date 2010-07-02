class HomePagesController < ApplicationController
  layout 'homepage'

  def index
    @home_page = HomePage.first
    @latest_news = NewsPost.published.latest(1).first
    @featured_property = @home_page.featured_property
  end
end
