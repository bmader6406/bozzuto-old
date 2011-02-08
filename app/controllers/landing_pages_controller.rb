class LandingPagesController < ApplicationController
  layout 'homepage'

  def show
    @page = LandingPage.published.find(params[:id])
    @state = @page.state
  end


  private

  def force_browser?
    true
  end
end
