class AreasController < ApplicationController
  def show
  end


  private

  def area
    @area ||= metro.areas.find(params[:id])
  end
  helper_method :area

  def metro
    @metro ||= Metro.find(params[:metro_id])
  end
  helper_method :metro
end
