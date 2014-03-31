module Bozzuto
  module ApartmentFloorPlans
    module HasCache
      def self.included(base)
        base.class_eval do
          has_one :apartment_floor_plan_cache,
                  :as        => :cacheable,
                  :dependent => :destroy

          delegate :cheapest_price_in_group,
                   :plan_count_in_group,
                   :min_rent,
                   :max_rent,
                   :to => :fetch_apartment_floor_plan_cache
        end
      end

      #:nocov:
      def floor_plans_for_caching
        raise NotImplementedError, "#{self.class.to_s} must implement #floor_plans_for_caching"
      end

      def floor_plans_in_group_for_caching(group)
        floor_plans_for_caching.in_group(group)
      end
      #:nocov:

      def invalidate_apartment_floor_plan_cache!
        apartment_floor_plan_cache.try(:invalidate!)
        self.apartment_floor_plan_cache = nil
        true
      end

      def fetch_apartment_floor_plan_cache
        apartment_floor_plan_cache || prime_apartment_floor_plan_cache
      end

      def prime_apartment_floor_plan_cache
        build_apartment_floor_plan_cache.tap do |cache|
          cache.update_cache
        end
      end
    end
  end
end
