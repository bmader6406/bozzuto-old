class HomePagesController < ApplicationController
  has_mobile_actions :index

  layout :detect_mobile_layout

  def index
    @home_page        = HomePage.first
    @section          = Section.about
    @latest_blog_post = BozzutoBlogPost.latest(1).first
  end


  private

  def detect_mobile_layout
    mobile? ? 'application' : 'homepage'
  end

  def latest_news
    base_scope = NewsPost.published.latest(1)

    @latest_news ||= base_scope.featured.first || base_scope.first
  end
  helper_method :latest_news

  def latest_awards
    #:nocov:
    @latest_awards ||= begin
    #:nocov:
      base_scope = Award.published

      featured   = base_scope.featured.latest(1).first
      unfeatured = base_scope.not_featured.latest(2).all

      [featured, unfeatured].compact.flatten.take(2)
    end
  end
  helper_method :latest_awards
end
