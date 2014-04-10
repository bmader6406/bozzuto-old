class AreasController < ApplicationController
  has_mobile_actions :show

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

  def listings
    @listings ||= if area.shows_neighborhoods?
      neighborhoods
    else
      area.communities
    end
  end
  helper_method :listings

  def nearby_areas
    @nearby_areas ||= area.nearby_areas
  end
  helper_method :nearby_areas

  def nearby_communities
    @nearby_communities ||= area.nearby_communities
  end
  helper_method :nearby_communities
end
