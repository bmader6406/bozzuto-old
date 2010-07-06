class SectionContentController < ApplicationController
  layout 'page'

  before_filter :find_section


  private

  def latest_news_posts(limit = 3)
    @latest_news_posts ||= section_news_posts.latest(limit).all
  end
  helper_method :latest_news_posts

  def latest_awards(limit = 3)
    @latest_awards ||= section_awards.latest(limit).all
  end
  helper_method :latest_awards


  def section_news_posts
    @section.aggregate? ? NewsPost.published : @section.news_posts.published
  end
  helper_method :section_news_posts

  def section_testimonials
    @section.aggregate? ? Testimonial.scoped({}) : @section.testimonials
  end
  helper_method :section_testimonials

  def section_awards
    @section.aggregate? ? Award.published : @section.awards.published
  end
  helper_method :section_awards

  def section_projects
    @section.projects.published
  end
  helper_method :section_projects
end
