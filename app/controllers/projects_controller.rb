class ProjectsController < ApplicationController
  include Bozzuto::ContentController

  has_mobile_actions :index, :show

  layout :detect_mobile_layout

  before_filter :find_our_work_page

  def index
    @projects ||= @section.projects.published
    respond_to do |format|
      format.html { render :action => :index, :layout => 'page' }
      format.mobile
    end
  end

  def show
    @project          = section_projects.friendly.find(params[:id])
    @updates          = @project.updates.published.paginate(:page => page_number)
    @related_projects = @project.related_projects
  end

  private

  def find_our_work_page
    @page = begin
      @section.pages.published.friendly.find('our-work')
    rescue
      nil
    end
  end

  def categories_with_projects
    #:nocov:
    @categories_with_projects ||= @categories.select do |category|
      category.projects.in_section(@section).order_by_completion_date.any?
    end
    #:nocov:
  end
  helper_method :categories_with_projects

  def detect_mobile_layout
    mobile? ? 'application' : 'project'
  end
end
