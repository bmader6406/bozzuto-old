class ProjectsController < SectionContentController
  has_mobile_actions :index, :show

  layout :detect_mobile_layout

  before_filter :find_our_work_page

  def index
    @categories = ProjectCategory.all

    respond_to do |format|
      format.html { render :action => :index, :layout => 'page' }
      format.mobile
    end
  end

  def show
    @project = section_projects.find(params[:project_id])
    @updates = @project.updates.published.paginate(:page => params[:page])
    @related_projects = @project.related_projects
  end


  private

  def find_our_work_page
    @page = begin
      @section.pages.published.find 'our-work'
    rescue
      nil
    end
  end

  def categories_with_projects
    @categories_with_projects ||= @categories.select do |category|
      category.projects.in_section(@section).order_by_completion_date.any?
    end
  end
  helper_method :categories_with_projects

  def detect_mobile_layout
  end

  def detect_mobile_layout
    mobile? ? 'application' : 'project'
  end
end
