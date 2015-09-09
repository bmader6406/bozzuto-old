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

  def default_news
    base_scope = NewsPost.published.latest(1)

    base_scope.featured.first || base_scope.first
  end

  def latest_awards
    #:nocov:
    @latest_awards ||= begin
    #:nocov:
      base_scope = Award.published

      featured   = base_scope.featured.latest(2).all
      unfeatured = base_scope.not_featured.latest(2).all

      [featured, unfeatured].compact.flatten.take(2)
    end
  end
  helper_method :latest_awards

  def featured_news
    @featured_news ||= Bozzuto::Homepage::FeaturableNews.featured_news || default_news
  end
  helper_method :featured_news

  def featured_news_url
    @featured_news_url ||= public_send("#{featured_news.class.name.underscore}_url", @section, featured_news)
  end
  helper_method :featured_news_url
end
