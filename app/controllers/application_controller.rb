class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery

  before_filter :detect_mobile_user_agent
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
    Section.about.pages.roots
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

  def detect_mobile_user_agent
    request.format = :mobile if request.env["HTTP_USER_AGENT"] =~ /(Mobile\/.+Safari)/
  end

  def mobile?
    request.format.to_sym == :mobile
  end
  helper_method :mobile?
end
