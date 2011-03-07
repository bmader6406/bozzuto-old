class ApplicationController < ActionController::Base
  include Bozzuto::Mobile
  include OverriddenPathsHelper

  helper :all
  protect_from_forgery

  around_filter :set_current_queue

  rescue_from ActiveRecord::RecordNotFound, :with => :render_404


  private

  def set_current_queue
    session[:recent_communities] ||= []
    RecentQueue.current_queue = session[:recent_communities]
    yield
    session[:recent_communities] = RecentQueue.current_queue
    Thread.current[:queue] = nil
  end

  def render_404
    render :text => 'Not found', :status => 404
  end

  def find_section
    @section = Section.find(params[:section])
  end

  def about_root_pages
    Section.about.pages.published.roots
  rescue
    []
  end
  helper_method :about_root_pages

  def states
    @states ||= State.ordered_by_name
  end
  helper_method :states

  def services
    @services ||= Section.services.ordered_by_title
  end
  helper_method :services

  def apartment_floor_plan_groups
    @apartment_floor_plan_groups ||= ApartmentFloorPlanGroup.all
  end
  helper_method :apartment_floor_plan_groups

  def page_url(section, page = nil)
    if section.service?
      service_section_page_url(section, page.try(:path))
    elsif section == Section.news_and_press
      news_and_press_page_url(page.try(:path))
    else
      section_page_url(section, page.try(:path))
    end
  end
  helper_method :page_url

  def typus_user
    @typus_user ||= Typus.user_class.find_by_id(session[:typus_user_id])
  end

  def detect_mobile_layout
    mobile? ? 'application' : 'community'
  end
end
