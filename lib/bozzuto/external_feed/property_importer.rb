module Bozzuto::ExternalFeed
  class PropertyImporter < Struct.new(:property_data, :feed_type)
    include Logging

    def import
      if property.persisted?
        import_floor_plans
        import_property_amenities
        import_office_hours
        import_units

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
      attrs = property_data.database_attributes

      if feed_type == :carmel
        attrs.delete(:title)
        attrs.delete(:street_address)
        attrs.delete(:availability_url)
      end

      p.attributes = attrs
    end

    def set_location_data_for(p)
      unless feed_type == :carmel && p.city.present?
        p.city = find_or_create_city(property_data.city, property_data.state)
      end
    end

    def import_floor_plans
      property_data.floor_plans.each do |plan_data|
        import_floor_plan(plan_data)
      end
    end

    def import_floor_plan(plan_data)
      find_or_initialize_floor_plan(plan_data) do |plan|
        plan.attributes          = plan_data.database_attributes
        plan.apartment_community = property

        # Only set floor plan group if this is a new plan
        if plan.new_record?
          plan.floor_plan_group = find_floor_plan_group(plan_data)
        end

        save(plan)
      end
    end

    def import_property_amenities
      property_data.property_amenities.to_a.each do |amenity_data|
        import_property_amenity(amenity_data)
      end
    end

    def import_property_amenity(amenity_data)
      amenity = property.property_amenities.find_or_initialize_by_primary_type_and_sub_type_and_description(
        amenity_data.primary_type,
        amenity_data.sub_type,
        amenity_data.description
      )

      amenity.attributes = amenity_data.database_attributes

      save(amenity)
    end

    def delete_orphaned_floor_plans
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

    def import_office_hours
      property_data.office_hours.each do |office_hour_data|
        ::OfficeHour.find_or_initialize_by_property_id_and_day(property.id, office_hour_data.day).tap do |office_hour|
          office_hour.update_attributes(office_hour_data.database_attributes)
        end
      end
    end

    def import_units
      property_data.apartment_units.each do |unit_data|
        unit = import_unit(unit_data)

        if unit.present? && unit.persisted?
          import_unit_amenities(unit, unit_data)
          import_files(unit, unit_data)
        end
      end
    end

    def import_unit(unit_data)
      plan = ApartmentFloorPlan.find_by_external_cms_id_and_external_cms_type(
        unit_data.floorplan_external_cms_id,
        unit_data.external_cms_type
      )

      return if plan.nil?

      find_or_initialize_unit(plan, unit_data) do |unit|
        unit.attributes = unit_data.database_attributes
        unit.floor_plan = plan
        save(unit)
      end
    end

    def import_unit_amenities(unit, unit_data)
      unit_data.apartment_unit_amenities.to_a.each do |amenity_data|
        import_unit_amenity(unit, amenity_data)
      end
    end

    def import_unit_amenity(unit, amenity_data)
      amenity = unit.amenities.find_or_initialize_by_primary_type_and_sub_type_and_description(
        amenity_data.primary_type,
        amenity_data.sub_type,
        amenity_data.description
      )

      amenity.attributes = amenity_data.database_attributes

      save(amenity)
    end

    def import_files(unit, unit_data)
      unit_data.files.to_a.each do |file_data|
        import_file(unit, file_data)
      end
    end

    def import_file(feed_record, file_data)
      find_or_initialize_file(file_data) do |file|
        file.attributes  = file_data.database_attributes
        file.feed_record = feed_record
        save(file)
      end
    end

    def find_or_initialize_property
      p = ApartmentCommunity.find_or_initialize_by_external_cms_id_and_external_cms_type(
        property_data.external_cms_id,
        property_data.external_cms_type
      )

      yield(p) if block_given?

      p
    end

    def find_or_initialize_floor_plan(data)
      plan = ApartmentFloorPlan.find_or_initialize_by_external_cms_id_and_external_cms_type(
        data.external_cms_id,
        data.external_cms_type
      )

      yield(plan) if block_given?

      plan
    end

    def find_or_initialize_unit(plan, data)
      unit = plan.apartment_units.find_or_initialize_by_external_cms_id_and_external_cms_type(
        data.external_cms_id,
        data.external_cms_type
      )

      yield(unit) if block_given?

      unit
    end

    def find_or_initialize_file(data)
      file = FeedFile.find_or_initialize_by_external_cms_id_and_external_cms_type_and_source(
        data.external_cms_id,
        data.external_cms_type,
        data.source
      )

      yield(file) if block_given?

      file
    end

    def find_floor_plan_group(data)
      ApartmentFloorPlanGroup.send(data.floor_plan_group)
    end

    def find_state(state)
      State.find_by_code(state)
    end

    def find_or_create_city(city_name, state_code)
      state = find_state(state_code)

      return unless state.present?

      state.cities.find_or_create_by_name(city_name)
    end

    def save(record)
      record.save or log_error("Failed to save #{record.class} due to errors: #{record.errors}")
    end
  end
end
