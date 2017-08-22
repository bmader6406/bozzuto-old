class AreasController < ApplicationController
  has_mobile_actions :show

  caches_action :show, expires_in: 2.minutes

  def show
  end

  private

  def metro
    @metro ||= Metro.friendly.find(params[:metro_id])
  end
  helper_method :metro

  def area
    @area ||= metro.areas.includes(
      :area_memberships,
      { neighborhoods: [:apartment_floor_plan_cache, neighborhood_memberships: { apartment_community: [ :property_features, :apartment_floor_plan_cache] }] },
      { apartment_communities: [:property_features, :apartment_floor_plan_cache] }
    ).friendly.find(params[:id])
  end
  helper_method :area

  def neighborhoods
    @neighborhoods ||= area.neighborhoods.positioned.select(&:has_communities?)
  end
  helper_method :neighborhoods

  def nearby_areas
    @nearby_areas ||= area.nearby_areas.select(&:has_communities?)
  end
  helper_method :nearby_areas

  def nearby_communities
    @nearby_communities ||= area.nearby_communities
  end
  helper_method :nearby_communities

  def filterer
    @filterer ||= Bozzuto::Neighborhoods::Filterer.new(area, params[:amenity_id])
  end
  helper_method :filterer
end
