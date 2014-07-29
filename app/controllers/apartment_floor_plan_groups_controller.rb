class ApartmentFloorPlanGroupsController < ApplicationController
  has_mobile_actions :index

  layout :detect_mobile_layout

  before_filter :find_community

  def index
  end


  private

  def find_community
    @community = find_property(ApartmentCommunity, params[:apartment_community_id])
  end

  def filtered_floor_plans
    @filtered_floor_plans ||= FilteredFloorPlansCollection.new(@community, params[:filter])
  end
  helper_method :filtered_floor_plans


  class FilteredFloorPlansCollection
    attr_reader :community, :filter

    def initialize(community, filter = 'all')
      @community = community
      @filter    = filter
    end

    def available_floor_plans
      if filter == 'available'
        base_scope.available
      else
        base_scope
      end
    end


    private

    def base_scope
      @community.floor_plans.with_square_footage
    end
  end
end
