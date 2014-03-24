class NeighborhoodsController < ApplicationController
  def show
  end


  private

  def metro
    @metro ||= Metro.find(params[:metro_id])
  end
  helper_method :metro

  def area
    @area ||= metro.areas.find(params[:area_id])
  end
  helper_method :area

  def neighborhood
    @neighborhood ||= area.neighborhoods.find(params[:id])
  end
  helper_method :neighborhood

  def neighborhood_memberships
    @neighborhood_memberships ||= neighborhood.neighborhood_memberships
  end
  helper_method :neighborhood_memberships
end
