class PressReleasesController < ApplicationController
  include Bozzuto::ContentController

  def index
    @press_releases = section_press_releases.paginate(:page => page_number)
  end

  def show
    @press_release = section_press_releases.friendly.find(params[:id])
  end
end
