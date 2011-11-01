class HomePagesController < ApplicationController
  has_mobile_actions :index

  layout :detect_mobile_layout

  def index
    @home_page = HomePage.first
    @latest_news = NewsPost.published.latest(1).first
  end


  private

  def detect_mobile_layout
    mobile? ? 'application' : 'homepage'
  end
end
