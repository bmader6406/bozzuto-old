class LandingPagesController < ApplicationController
  browser_only!

  layout 'homepage'

  before_filter :find_page, :only => :show
  before_filter :redirect_to_canonical_url, :only => :show

  def show
    @state = @page.state
  end


  private

  def find_page
    @page = LandingPage.published.find(params[:id])
  end

  def redirect_to_canonical_url
    if request.path != landing_page_path(@page)
      redirect_to @page, :status => :moved_permanently
    end
  end
end
