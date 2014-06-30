module Bozzuto
  module ExternalFeed
    class Loader
      class_attribute :load_interval

      self.load_interval = 2.hours

      def self.loader_for_type(type, opts = {})
        opts.assert_valid_keys(:file)

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

      def lock_file
        Rails.root.join("tmp/#{feed_type}.lock")
      end

      def tmp_file
        Rails.root.join("tmp/#{feed_type}")
      end

      def feed_already_loading?
        File.exists?(lock_file)
      end

      def can_load_feed?
        !feed_already_loading? && Time.now >= next_load_at
      end

      def next_load_at
        if last_loaded_at
          last_loaded_at + load_interval
        else
          Time.now - 1.minute
        end
      end

      def last_loaded_at
        if File.exists?(tmp_file)
          File.new(tmp_file).mtime
        else
          nil
        end
      end

      def load!
        return false unless can_load_feed?

        begin
          touch_lock_file
          process_feed
          touch_tmp_file
        ensure
          rm_lock_file
        end

        true
      end


      private

      #:nocov:
      def touch_tmp_file
        FileUtils.touch(tmp_file)
      end

      def touch_lock_file
        FileUtils.touch(lock_file)
      end

      def rm_lock_file
        File.delete(lock_file) if File.exists?(lock_file)
      end
      #:nocov:

      def process_feed
        ActiveRecord::Base.transaction do
          feed.properties.each do |property_data|
            property = import_property(property_data)

            unless property.new_record?
              import_floor_plans(property, property_data)
            end
          end

          true
        end
      end

      def import_property(property_data)
        find_or_initialize_property(property_data) do |property|
          property.attributes = property_data.database_attributes
          property.city       = find_or_create_city(property_data.city, property_data.state)
          property.county     = find_or_create_county(property_data.county, property_data.city, property_data.state)

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
          plan.attributes         = plan_data.database_attributes
          plan.apartment_community = property

          # Only set floor plan group if this is a new plan
          if plan.new_record?
            plan.floor_plan_group = find_floor_plan_group(plan_data)
          end

          plan.save
        end
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

      def find_or_create_county(county_name, city_name, state_code)
        state = find_state(state_code)
        city  = find_or_create_city(city_name, state_code)

        return unless state.present? && county_name.present?

        # Find or create the county
        county = state.counties.find_or_create_by_name(county_name)

        # Add the county to the city's list of counties
        unless city.counties.include?(county)
          city.counties << county
        end

        county
      end
    end
  end
end
