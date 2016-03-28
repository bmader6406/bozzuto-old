module Bozzuto
  module ContentController
    def self.included(base)
      base.class_eval do
        layout :detect_mobile_layout

        before_filter :find_section

        helper_method :latest_news_posts,
                      :latest_awards,
                      :section_news_posts,
                      :section_press_releases,
                      :section_testimonials,
                      :section_awards,
                      :section_projects,
                      :current_page_path
      end
    end


    private

    def detect_mobile_layout
      mobile? ? 'application' : 'page'
    end

    def latest_news_posts(limit = 3)
      @latest_news_posts ||= section_news_posts.latest(limit).all
    end

    def latest_awards(limit = 3)
      @latest_awards ||= section_awards.latest(limit).all
    end


    def section_news_posts
      @section.aggregate? ? NewsPost.published : @section.news_posts.published
    end

    def section_press_releases
      @section.aggregate? ? PressRelease.published : @section.press_releases.published
    end

    def section_testimonials
      @section.aggregate? ? Testimonial.all : @section.testimonials
    end

    def section_awards
      @section.aggregate? ? Award.published : @section.awards.published
    end

    def section_projects
      @section.projects.published
    end

    def current_page_path
      # This is a hack to get around pagination issues.
      if @page.present? && @page.path.present?
        @page.path
      else
        params[:page]
      end
    end
  end
end
