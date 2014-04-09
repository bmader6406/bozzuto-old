class NeighborhoodsController < ApplicationController
  has_mobile_actions :show

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

  def nearby_neighborhoods
    @nearby_neighborhoods ||= neighborhood.nearby_neighborhoods
  end
  helper_method :nearby_neighborhoods

  def nearby_communities
    @nearby_communities ||= neighborhood.nearby_communities
  end
  helper_method :nearby_communities
end
