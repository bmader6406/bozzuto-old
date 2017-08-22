class NeighborhoodsController < ApplicationController
  has_mobile_actions :show

  caches_action :show, expires_in: 1.minutes

  def show
  end

  private

  def metro
    @metro ||= Metro.friendly.find(params[:metro_id])
  end
  helper_method :metro

  def area
    @area ||= metro.areas.friendly.find(params[:area_id])
  end
  helper_method :area

  def neighborhood
    @neighborhood ||= area.neighborhoods.includes(
      neighborhood_memberships: { apartment_community: [ :property_features, :apartment_floor_plan_cache] }
    ).friendly.find(params[:id])
  end
  helper_method :neighborhood

  def nearby_neighborhoods
    @nearby_neighborhoods ||= neighborhood.nearby_neighborhoods.select(&:has_communities?)
  end
  helper_method :nearby_neighborhoods

  def nearby_communities
    @nearby_communities ||= neighborhood.nearby_communities
  end
  helper_method :nearby_communities

  def filterer
    @filterer ||= Bozzuto::Neighborhoods::Filterer.new(neighborhood, params[:amenity_id])
  end
  helper_method :filterer
end
