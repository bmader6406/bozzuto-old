module Bozzuto
  class ExternalFeedLoader
    class_attribute :feed_type
    class_attribute :tmp_file
    class_attribute :lock_file
    class_attribute :load_interval

    self.load_interval = 2.hours

    def self.feed_types
      %w(vaultware property_link rent_cafe psi)
    end

    def self.loader_for_type(type)
      case type.to_sym
      when :vaultware
        VaultwareFeedLoader.new
      when :property_link
        PropertyLinkFeedLoader.new
      when :rent_cafe
        RentCafeFeedLoader.new
      when :psi
        PsiFeedLoader.new
      else
        raise "Unknown feed type: #{type}"
      end
    end


    def self.define_feed_attribute(attr)
      class_attribute "_#{attr}"

      class_eval <<-END
        def self.#{attr}(selector = nil, opts = {})
          if selector
            opts.symbolize_keys!
            opts[:selector] = selector

            self._#{attr} = opts
          else
            self._#{attr}
          end
        end
      END
    end

    %w(
      title
      external_cms_id
      street_address
      availability_url
      state
      city
      county
      floor_plan_external_cms_id
      floor_plan_name
      floor_plan_comment
      floor_plan_availability_url
      floor_plan_available_units
      floor_plan_bedroom_count
      floor_plan_bathroom_count
      floor_plan_min_square_feet
      floor_plan_max_square_feet
      floor_plan_min_market_rent
      floor_plan_max_market_rent
      floor_plan_min_effective_rent
      floor_plan_max_effective_rent
      office_hour_open_time
      office_hour_close_time
      office_hour_day
    ).each do |attr|
      define_feed_attribute(attr)
    end


    attr_accessor :file


    def feed_name
      self.class.feed_type.to_s.classify
    end

    def feed_already_loading?
      File.exists?(self.class.lock_file)
    end

    def can_load_feed?
      if !feed_already_loading? && Time.now >= next_load_time
        true
      else
        false
      end
    end

    def next_load_time
      #:nocov:
      if last_loaded_at
        last_loaded_at + self.class.load_interval
      else
        Time.now - 1.minute
      end
      #:nocov:
    end

    def last_loaded_at
      #:nocov:
      if File.exists?(self.class.tmp_file)
        File.new(self.class.tmp_file).mtime
      else
        nil
      end
      #:nocov:
    end

    def load
      return false unless can_load_feed?

      begin
        touch_lock_file
        load_feed
        touch_tmp_file
      ensure
        rm_lock_file
      end

      true
    end

    def value_for(node, attr)
      config = self.class.send(attr)

      return nil unless config.present?

      final_node = node.at(config[:selector])

      if config[:attribute].present?
        final_node.try(:[], config[:attribute])
      else
        final_node.try(:content)
      end
    end


    private

    def load_feed
      data = Nokogiri::XML(File.read(file))

      data.remove_namespaces!

      data.xpath('/PhysicalProperty/Property').each do |property|
        if process_property(property)
          # Only process floor plans and office hours if the community
          # was successfully created or updated
          process_floor_plans(property)
          process_office_hours(property)
        end
      end
    end

    def touch_tmp_file
      system "touch #{self.class.tmp_file}"
    end

    def touch_lock_file
      system "touch #{self.class.lock_file}"
    end

    def rm_lock_file
      system "rm #{self.class.lock_file}"
    end


    def process_property(property)
      @community = ApartmentCommunity.find_or_initialize_by_external_cms_id_and_external_cms_type(
        value_for(property, :external_cms_id),
        self.class.feed_type.to_s
      )

      city = find_city(property)

      # Sometimes Bozzuto adds communities without an address. Our app requires city and state,
      # so if it's not present, then just skip this property
      if city.present?
        @community.update_attributes({
          :title            => value_for(property, :title),
          :street_address   => value_for(property, :street_address),
          :city             => city,
          :county           => find_county(property),
          :availability_url => value_for(property, :availability_url)
        })
      else
        false
      end
    end

    def rolled_up?(property)
      # a rolled up property has one or more floor plans elements with
      # two or more file children
      property.xpath('./Floorplan').any? { |plan|
        plan.xpath('./File').count > 1
      }
    end

    def process_floor_plans(property)
      rolled_up = rolled_up?(property)
      # rolled up floor plans use the File with a rank of 1
      # unrolled floor plans just use the first File
      file_selector = rolled_up ? './File[Rank=1]' : './File'

      property.xpath('./Floorplan').each do |plan|
        attrs = floor_plan_attributes(plan)
        file  = plan.at(file_selector)

        attrs.merge!(
          :external_cms_file_id => (file['Id'] rescue nil),
          :image_url            => (file.at('./Src').content rescue nil),
          :rolled_up            => rolled_up
        )

        create_or_update_floor_plan(attrs)
      end
    end

    def create_or_update_floor_plan(attrs)
      # don't change floor plan group on update -- penthouse doesn't come
      # over in the feed, so admins need to be able to change group
      # and have it persist

      plan = @community.floor_plans.managed_by_feed(attrs[:external_cms_id], attrs[:external_cms_type]).first

      if plan.present?
        plan.update_attributes(attrs.delete_if { |k, v| k == :floor_plan_group })
      else
        @community.floor_plans << ApartmentFloorPlan.new(attrs)
      end
    end

    def floor_plan_group(plan)
      bedrooms = value_for(plan, :floor_plan_bedroom_count).to_i
      comment  = value_for(plan, :floor_plan_comment)

      message = case
      when comment.present? && comment =~ /penthouse/i
        :penthouse
      when bedrooms == 0
        :studio
      when bedrooms == 1
        :one_bedroom
      when bedrooms == 2
        :two_bedrooms
      else
        :three_bedrooms
      end

      ApartmentFloorPlanGroup.send(message)
    end

    def floor_plan_attributes(plan)
      external_cms_id_config = self.class.send(:floor_plan_external_cms_id)

      {
        :floor_plan_group   => floor_plan_group(plan),
        :name               => value_for(plan, :floor_plan_name),
        :availability_url   => value_for(plan, :floor_plan_availability_url),
        :available_units    => value_for(plan, :floor_plan_available_units).to_i,
        :bedrooms           => (value_for(plan, :floor_plan_bedroom_count) || 0).to_i,
        :bathrooms          => value_for(plan, :floor_plan_bathroom_count).to_f,
        :min_square_feet    => value_for(plan, :floor_plan_min_square_feet).to_i,
        :max_square_feet    => value_for(plan, :floor_plan_max_square_feet).to_i,
        :min_market_rent    => value_for(plan, :floor_plan_min_market_rent).to_f,
        :max_market_rent    => value_for(plan, :floor_plan_max_market_rent).to_f,
        :min_effective_rent => value_for(plan, :floor_plan_min_effective_rent).to_f,
        :max_effective_rent => value_for(plan, :floor_plan_max_effective_rent).to_f,
        :external_cms_id    => plan[ external_cms_id_config[:attribute] ],
        :external_cms_type  => self.class.feed_type.to_s
      }
    end

    def find_city(property)
      state_code  = value_for(property, :state)
      city_name   = value_for(property, :city)

      state = State.find_by_code(state_code)

      if state.present?
        state.cities.find_or_create_by_name(city_name)
      else
        nil
      end
    end

    def find_county(property)
      county_name = value_for(property, :county)

      if county_name.present?
        state_code  = value_for(property, :state)
        city_name   = value_for(property, :city)

        state = State.find_by_code(state_code)

        city = state.cities.find_or_create_by_name(city_name)
        county = state.counties.find_or_create_by_name(county_name)

        unless city.counties.include?(county)
          city.counties << county
        end

        county
      else
        nil
      end
    end

    def office_hour_attributes(hour)
      {
        :open_time  => value_for(hour, :office_hour_open_time),
        :close_time => value_for(hour, :office_hour_close_time),
        :day        => value_for(hour, :office_hour_day)
      }
    end

    def process_office_hours(property)
      hours = property.xpath('./Information/OfficeHour').collect do |hour|
        office_hour_attributes(hour)
      end

      @community.update_attribute(:office_hours, hours)
    end
  end
end
