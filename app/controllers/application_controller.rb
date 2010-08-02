class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery

  around_filter :set_current_queue

  rescue_from ActiveRecord::RecordNotFound, :with => :redirect_home

  private

  def set_current_queue
    session[:recent_communities] ||= []
    RecentQueue.current_queue = session[:recent_communities]
    yield
    session[:recent_communities] = RecentQueue.current_queue
    Thread.current[:queue] = nil
  end

  def redirect_home
    redirect_to root_url
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
end
