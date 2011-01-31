class PressReleasesController < SectionContentController
  before_filter :find_section

  def index
    @press_releases = section_press_releases.paginate(:page => params[:page])
  end

  def show
    @press_release = section_press_releases.find(params[:press_release_id])
  end


  private

  def force_browser?
    true
  end
end
