class GreenHomesController < ApplicationController
  include Bozzuto::ContentController

  before_filter :find_page

  def index
    render :layout => (all_green_home_communities.any? ? 'green_homes' : 'page')
  end

  def show
    @community     = HomeCommunity.with_green_package.find(params[:id])
    @green_package = @community.green_package

    render :layout => 'application'
  end


  private

  def find_section
    @section = Section.find('new-homes')
  end

  def find_page
    @page = if typus_user
      @section.pages.find_by_path('green-homes')
    else
      @section.pages.published.find_by_path('green-homes')
    end

    render_404 if @page.nil?
  end

  def all_green_home_communities
    @all_green_home_communities ||= HomeCommunity.published.with_green_package.ordered_by_title
  end
  helper_method :all_green_home_communities
end
