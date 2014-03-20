class AreasController < ApplicationController
  def show
  end


  private

  def metro
    @metro ||= Metro.find(params[:metro_id])
  end
  helper_method :metro

  def area
    @area ||= metro.areas.find(params[:id])
  end
  helper_method :area

  def neighborhoods
    @neighborhoods ||= area.neighborhoods.positioned
  end
  helper_method :neighborhoods
end
