class LandingPagesController < ApplicationController
  layout 'homepage'

  def show
    @page = LandingPage.find(params[:id])
  end
end
