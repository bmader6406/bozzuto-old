class SectionContentController < ApplicationController
  layout :detect_mobile_layout

  before_filter :find_section, :find_news_and_press_section


  private

  def detect_mobile_layout
    mobile? ? 'application' : 'page'
  end

  def find_news_and_press_section
    @news_section = if @section.about?
      Section.news_and_press
    else
      nil
    end
  end

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

  def section_press_releases
    @section.aggregate? ? PressRelease.published : @section.press_releases.published
  end
  helper_method :section_press_releases

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

  def current_page_path
    # TODO This is a hack to get around pagination issues.
    if @page.present? && @page.path.present?
      @page.path
    elsif params[:page].present? && params[:page].respond_to?(:join)
      params[:page].join('/')
    end
  end
  helper_method :current_page_path
end
