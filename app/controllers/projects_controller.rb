class ProjectsController < SectionContentController
  layout 'project'

  def index
    @projects = section_projects
    render :action => :index, :layout => 'page'
  end

  def show
    @project = section_projects.find(params[:project_id])
    @updates = @project.updates.published.paginate(:page => params[:page])
  end
end
