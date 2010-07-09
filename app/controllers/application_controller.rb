class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery

  around_filter :set_current_queue

  # rescue_from ActiveRecord::RecordNotFound, :with => :render_404


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
  rescue ActiveRecord::RecordNotFound
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
