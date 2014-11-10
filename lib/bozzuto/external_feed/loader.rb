module Bozzuto
  module ExternalFeed
    class Loader
      include LoadingProcess

      allow_loading_every 2.hours

      def self.loader_for_type(type, opts = {})
        opts.assert_valid_keys(:file)

        identify_loading_process_as type

        new(Bozzuto::ExternalFeed::Feed.feed_for_type(type, opts[:file]))
      end

      attr_accessor :feed

      delegate :feed_name, :feed_type, :to => :feed

      def initialize(feed)
        @feed = feed
      end

      def file=(new_file)
        feed.file = new_file
      end

      def load!
        run_load_process { process_feed }
      end

      private

      def process_feed
        feed.properties.each do |property_data|
          property = import_property(property_data)

          unless property.new_record?
            import_floor_plans(property, property_data)
          end

          delete_orphaned_floor_plans(property, property_data)
        end

        true
      end

      def write_attributes_to(property, property_data)
        attrs = property_data.database_attributes

        if feed_type == :carmel
          attrs.delete(:title)
          attrs.delete(:street_address)
          attrs.delete(:availability_url)
        end

        property.attributes = attrs
      end

      def import_property(property_data)
        find_or_initialize_property(property_data) do |property|
          write_attributes_to(property, property_data)

          unless feed_type == :carmel && property.city.present?
            property.city = find_or_create_city(property_data.city, property_data.state)
          end

          property.save
        end
      end

      def import_floor_plans(property, property_data)
        property_data.floor_plans.each do |plan_data|
          import_floor_plan(property, plan_data)
        end
      end

      def import_floor_plan(property, plan_data)
        find_or_initialize_floor_plan(plan_data) do |plan|
          plan.attributes          = plan_data.database_attributes
          plan.apartment_community = property

          # Only set floor plan group if this is a new plan
          if plan.new_record?
            plan.floor_plan_group = find_floor_plan_group(plan_data)
          end

          plan.save
        end
      end

      def delete_orphaned_floor_plans(property, property_data)
        return unless property_data.floor_plans.any?

        # get floor plan ids from database
        plan_ids = property_data.floor_plans.map do |plan_data|
          property.floor_plans.
            managed_by_feed(plan_data.external_cms_id, plan_data.external_cms_type).
            first.
            try(:id)
        end.compact

        # delete all plans from this property that aren't in the feed
        property.floor_plans.where(['id NOT IN (?)', plan_ids]).map(&:destroy)
      end

      def find_or_initialize_property(c)
        property = ApartmentCommunity.find_or_initialize_by_external_cms_id_and_external_cms_type(
          c.external_cms_id,
          c.external_cms_type
        )

        yield(property) if block_given?

        property
      end

      def find_or_initialize_floor_plan(f)
        plan = ApartmentFloorPlan.find_or_initialize_by_external_cms_id_and_external_cms_type(
          f.external_cms_id,
          f.external_cms_type
        )

        yield(plan) if block_given?

        plan
      end

      def find_floor_plan_group(f)
        ApartmentFloorPlanGroup.send(f.floor_plan_group)
      end

      def find_state(state)
        State.find_by_code(state)
      end

      def find_or_create_city(city_name, state_code)
        state = find_state(state_code)

        return unless state.present?

        state.cities.find_or_create_by_name(city_name)
      end
    end
  end
end
