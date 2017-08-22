class MetrosController < ApplicationController
  has_mobile_actions :index, :show

  caches_action :index, expires_in: 5.minutes
  caches_action :show,  expires_in: 5.minutes

  def index
  end

  def show
  end


  private

  def states
    @states ||= State.positioned
  end
  helper_method :states

  def base_scope
    @base_scope ||= Metro.includes(areas: [
      :apartment_floor_plan_cache,
      :area_memberships,
      { neighborhoods: { neighborhood_memberships: { apartment_community: [ :property_features, :apartment_floor_plan_cache] } } },
      { apartment_communities: [:property_features, :apartment_floor_plan_cache] }
    ])
  end

  def metros
    @metros ||= base_scope.positioned.select(&:has_communities?)
  end
  helper_method :metros

  def metro
    @metro ||= base_scope.friendly.find(params[:id])
  end
  helper_method :metro

  def areas
    @areas ||= metro.areas.positioned.select(&:has_communities?)
  end
  helper_method :areas
end
