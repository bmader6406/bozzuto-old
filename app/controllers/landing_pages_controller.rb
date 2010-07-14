class LandingPagesController < ApplicationController
  layout 'homepage'

  def show
    @page = LandingPage.find(params[:id])
    @state = @page.state
  end
end
