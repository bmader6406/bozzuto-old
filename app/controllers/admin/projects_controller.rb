# Controller generated by Typus, use it to extend admin functionality.
class Admin::ProjectsController < Admin::MasterController
  def list_deleted
    set_fields
    items_count = Project::Archive.count
    items_per_page = Project.typus_options_for(:per_page).to_i

    @pager = ::Paginator.new(items_count, items_per_page) do |offset, per_page|
      Project::Archive.find(:all, :limit => per_page, :offset => offset, :order => 'title ASC').map {|item| 
        item.becomes(Project)
      }
    end

    @items = @pager.page(params[:page])
    
    respond_to do |format|
      format.html
    end
  end
end
