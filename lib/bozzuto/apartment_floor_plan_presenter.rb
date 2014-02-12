module Bozzuto
  class ApartmentFloorPlanPresenter
    attr_reader :community

    def initialize(community)
      @community = community
    end

    def groups
      @groups ||= community.floor_plan_groups.map { |g| FloorPlanGroup.new(community, g) }
    end

    def has_plans?
      groups.any?(&:has_plans?)
    end


    class FloorPlanGroup < Proxy
      attr_reader :community, :group

      delegate :with_largest_square_footage, :to => :plans

      def initialize(community, group)
        @community = community
        @group     = group

        super(group)
      end

      def has_plans?
        community.plan_count_in_group(group) > 0
      end

      def name
        group.plural_name
      end

      def plans
        @plans ||= community.available_floor_plans.in_group(group)
      end

      def largest_square_footage
        with_largest_square_footage.try(:min_square_feet)
      end

      def cheapest_rent
        community.cheapest_price_in_group(group)
      end
    end
  end
end
