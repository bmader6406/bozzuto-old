class LandingPagesController < ApplicationController
  browser_only!

  layout 'homepage'

  def show
    @page = LandingPage.published.find(params[:id])
    @state = @page.state
  end
end
