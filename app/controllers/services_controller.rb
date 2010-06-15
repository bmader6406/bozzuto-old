class ServicesController < ApplicationController
  def index
  end

  def show
    @service = Service.find_by_slug(params[:id])
  end
end
