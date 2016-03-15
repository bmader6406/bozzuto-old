module Bozzuto
  module ExternalFeed
    class PropertyImporter < Struct.new(:property_data, :feed_type)
      include Logging

      def import
        if property.persisted?
          persist floor_plans
          persist property_amenities
          persist office_hours
          persist units, :sync => true
          persist unit_amenities
          persist files

          CoreIdManager.new(property).assign_id

          delete_orphaned_floor_plans
        end

        property
      end

      private

      def property
        @property ||= find_or_initialize_property do |p|
          write_attributes_to(p)

          set_location_data_for(p)

          save(p)
        end
      end

      def write_attributes_to(p)
        attrs = property_data.database_attributes.merge(:found_in_latest_feed => true)

        p.attributes = attrs
      end

      def set_location_data_for(p)
        p.city = find_or_create_city(property_data.city, property_data.state)
      end

      def persist(records, options = {})
        return if records.empty?

        records.first.class.tap do |klass|
          if options[:sync]
            klass.transaction { records.each(&:save) }
          else
            klass.import(records, :on_duplicate_key_update => klass.column_names - blacklisted_columns)
          end
        end
      end

      def floor_plans
        @floor_plans ||= property_data.floor_plans.map do |plan_data|
          find_or_initialize_floor_plan(plan_data) do |plan|
            plan.attributes          = plan_data.database_attributes
            plan.apartment_community = property

            # Only set floor plan group if this is a new plan
            if plan.new_record?
              plan.floor_plan_group = find_floor_plan_group(plan_data)
            end
          end
        end
      end

      def property_amenities
        @property_amenities ||= property_data.property_amenities.to_a.map do |amenity_data|
          ::PropertyAmenity.find_or_initialize_by(
            property:     property,
            primary_type: amenity_data.primary_type,
            sub_type:     amenity_data.sub_type,
            description:  amenity_data.description
          ).tap { |amenity| amenity.attributes = amenity_data.database_attributes }
        end
      end

      def office_hours
        @office_hours ||= property_data.office_hours.map do |office_hour_data|
          ::OfficeHour.find_or_initialize_by(
            property_id:   property.id,
            property_type: 'ApartmentCommunity',
            day:           office_hour_data.day
          ).tap { |office_hour| office_hour.attributes = office_hour_data.database_attributes }
        end
      end

      def units
        @units ||= property_data.apartment_units.map do |unit_data|
          unit = import_unit(unit_data)

          RecordWrapper.new(unit).store(unit_data) if unit.present?
        end.compact
      end

      def import_unit(unit_data)
        plan = ApartmentFloorPlan.find_by(
          external_cms_id:   unit_data.floorplan_external_cms_id,
          external_cms_type: unit_data.external_cms_type
        )

        return if plan.nil?

        find_or_initialize_unit(unit_data) do |unit|
          unit.attributes = unit_data.database_attributes.merge(:include_in_export => true)
          unit.floor_plan = plan
        end
      end

      def unit_amenities
        @unit_amenities ||= units.flat_map do |unit|
          unit.data.apartment_unit_amenities.to_a.map do |amenity_data|
            unit.amenities.find_or_initialize_by(
              primary_type: amenity_data.primary_type,
              sub_type:     amenity_data.sub_type,
              description:  amenity_data.description
            ).tap do |amenity|
              amenity.attributes = amenity_data.database_attributes
            end
          end
        end
      end

      def files
        @files ||= units.flat_map do |unit|
          unit.data.files.to_a.map do |file_data|
            find_or_initialize_file(file_data) do |file|
              file.attributes  = file_data.database_attributes
              file.feed_record = unit
            end
          end
        end
      end

      def find_or_initialize_property
        ApartmentCommunity.find_or_initialize_by(
          external_cms_id:   property_data.external_cms_id,
          external_cms_type: property_data.external_cms_type
        ).tap { |property| yield(property) if block_given? }
      end

      def find_or_initialize_floor_plan(data)
        ApartmentFloorPlan.find_or_initialize_by(
          external_cms_id:   data.external_cms_id,
          external_cms_type: data.external_cms_type
        ).tap { |plan| yield(plan) if block_given? }
      end

      def find_or_initialize_unit(data)
        ::ApartmentUnit.find_or_initialize_by(
          external_cms_id:           data.external_cms_id,
          external_cms_type:         data.external_cms_type,
          floorplan_external_cms_id: data.floorplan_external_cms_id
        ).tap { |unit| yield(unit) if block_given? }
      end

      def find_or_initialize_file(data)
        FeedFile.find_or_initialize_by(
          external_cms_id:   data.external_cms_id,
          external_cms_type: data.external_cms_type,
          source:            data.source
        ).tap { |file| yield(file) if block_given? }
      end

      def find_floor_plan_group(data)
        ApartmentFloorPlanGroup.send(data.floor_plan_group)
      end

      def find_state(state)
        State.find_by(code: state)
      end

      def find_or_create_city(city_name, state_code)
        state = find_state(state_code)

        return unless state.present?

        state.cities.find_or_create_by(name: city_name)
      end

      def blacklisted_columns
        [
          'created_at',
          'updated_at'
        ]
      end

      def delete_orphaned_floor_plans
        return unless property_data.floor_plans.any?

        plan_ids = property_data.floor_plans.map(&:external_cms_id)

        property.floor_plans.where('apartment_floor_plans.external_cms_id NOT IN (?)', plan_ids).destroy_all
      end

      def save(record)
        record.save or log_error("Failed to save #{record.class} due to errors: #{record.errors}")
      end

      class RecordWrapper < SimpleDelegator
        attr_reader :data

        def store(data)
          tap { @data = data }
        end

        def class
          __getobj__.class
        end
      end
    end
  end
end
