class ApplicationController < ActionController::Base
  include OverriddenPathsHelper
  include Bozzuto::SslRequirement
  include Bozzuto::Mobile::Controller
  include Analytics::AdSource::Controller
  include Analytics::MillenialMedia::Controller

  helper :all
  protect_from_forgery

  around_filter :set_current_queue

  unless Rails.env.development?
    rescue_from ActiveRecord::RecordNotFound,
                ActionView::MissingTemplate,
                :with => :render_404
  end


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
    @section = Section.friendly.find(section_param)
  end

  def section_param
    params[:section].presence && params[:section].sub('services/', '')
  end

  def find_property(klass, id)
    base_scope = (admin_user || params[:preview] == 'true') ? klass : klass.published

    base_scope.friendly.find(id)
  end

  def about_root_pages
    Section.about.pages.published.roots
  rescue
    []
  end
  helper_method :about_root_pages

  def page_number
    [1, params[:page].to_i].max
  end
  helper_method :page_number

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

  def admin_user
    @admin_user ||= warden.authenticate
  end

  def detect_mobile_layout
    mobile? ? 'application' : 'community'
  end

  VIGET_IPS = [
    /^70\.182\.186\.(9[6-9]|1([0-1][0-9]|2[0-7]))$/,
    /^96\.10\.0\.146$/,
    /^96\.49\.115\.54$/,
    /^67\.176\.76\.149$/,
    /^173\.8\.242\.217$/,
    /^50\.52\.128\.102$/
  ]

  def viget_ip?
    VIGET_IPS.any? { |regex| regex =~ request.remote_ip }
  end
  helper_method :viget_ip?
end
