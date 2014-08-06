class PressReleasesController < SectionContentController
  before_filter :find_section

  def index
    @press_releases = section_press_releases.paginate(:page => page_number)
  end

  def show
    @press_release = section_press_releases.find(params[:press_release_id])
  end
end
