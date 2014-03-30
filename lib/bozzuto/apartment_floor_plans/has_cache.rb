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
                   :update_apartment_floor_plan_cache,
                   :update_apartment_floor_plan_cache_for_group,
                   :to => :fetch_apartment_floor_plan_cache
        end
      end

      #:nocov:
      def floor_plans_in_group_for_caching(group)
        raise NotImplementedError, "#{self.class.to_s} must implement #floor_plans_in_group_for_caching"
      end

      def floor_plans_for_caching
        raise NotImplementedError, "#{self.class.to_s} must implement #floor_plans_for_caching"
      end
      #:nocov:


      private

      def fetch_apartment_floor_plan_cache
        apartment_floor_plan_cache || build_apartment_floor_plan_cache
      end
    end
  end
end
