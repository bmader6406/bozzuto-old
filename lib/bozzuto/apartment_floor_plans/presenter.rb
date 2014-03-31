module Bozzuto
  module ApartmentFloorPlans
    class Presenter
      attr_reader :presentable

      def initialize(presentable)
        @presentable = presentable
      end

      def groups
        @groups ||= ApartmentFloorPlanGroup.all.map { |g| FloorPlanGroup.new(presentable, g) }
      end

      def has_plans?
        groups.any?(&:has_plans?)
      end


      class FloorPlanGroup < Proxy
        attr_reader :presentable, :group

        delegate :with_largest_square_footage, :to => :plans

        def initialize(presentable, group)
          @presentable = presentable
          @group     = group

          super(group)
        end

        def has_plans?
          presentable.plan_count_in_group(group) > 0
        end

        def name
          group.plural_name
        end

        def plans
          @plans ||= presentable.available_floor_plans.in_group(group)
        end

        def largest_square_footage
          with_largest_square_footage.try(:min_square_feet)
        end

        def cheapest_rent
          presentable.cheapest_price_in_group(group)
        end
      end
    end
  end
end
