require 'benchmark'

module Bozzuto
  module ExternalFeed
    class Feed
      include Logging

      class_attribute :feed_type
      class_attribute :default_file

      attr_reader :file

      class FeedNotFound < IOError; end

      class << self
        def feed_types
          %w(vaultware rent_cafe property_link psi carmel)
        end

        def feed_for_type(type, file = nil)
          "Bozzuto::ExternalFeed::#{type.to_s.classify}Feed".constantize.new(file)
        end

        def feed_name(type)
          I18n.t!("bozzuto.feeds.#{type}") if type.present?
        end

        def logger
          @logger ||= Logger.new($stdout)
        end
      end

      def initialize(file = nil)
        @file = file || default_file
      end

      def feed_name
        self.class.feed_name(feed_type)
      end

      def process
        assert_file_exists

        # Reset include_in_export flag on all Property Link units
        ApartmentUnit.where(:external_cms_type => 'property_link').update_all(:include_in_export => false)

        report { NodeFinder.new(self).parse }
      end

      def collect(property_node)
        log_debug("Building property data from XML property node...")

        build_property(property_node).tap do |property_data|
          log_info("Finished building property data from XML for #{property_data.title}.")
          log_debug("Importing property data for #{property_data.title}...")

          data       << property_data
          properties << PropertyImporter.new(property_data, feed_type).import

          log_info("Finished importing property data for #{property_data.title}.")
        end
      end

      def file=(new_file)
        @file       = new_file
        @data       = nil
        @properties = nil
      end

      def data
        @data ||= []
      end

      def properties
        @properties ||= []
      end

      private

      def assert_file_exists
        unless file.present? && ::File.exists?(file)
          raise FeedNotFound.new("File not found: #{file.inspect}")
        end
      end

      # Builder methods. Override these in the subclass to build the objects

      def build_property(property)
        raise NotImplementedError, "#{self.class.to_s} must implement #build_property"
      end

      def build_floor_plans(property)
        property.xpath('./Floorplan').map do |plan|
          build_floor_plan(property, plan)
        end
      end

      def build_floor_plan(property, plan)
        raise NotImplementedError, "#{self.class.to_s} must implement #build_floor_plan"
      end

      def build_property_amenities(property)
        property.xpath('./Amenity').map do |amenity|
          build_property_amenity(amenity)
        end
      end

      def build_property_amenity(amenity)
        Bozzuto::ExternalFeed::PropertyAmenity.new(
          :primary_type => amenity['Type'],
          :sub_type     => amenity['SubType'],
          :description  => string_at(amenity, './Description'),
          :position     => int_at(amenity, './Rank')
        )
      end

      def build_apartment_units(property)
        property.xpath('./ILS_Unit').map do |unit|
          build_apartment_unit(property, unit)
        end
      end

      def build_apartment_unit(property, unit)
        raise NotImplementedError, "#{self.class.to_s} must implement #build_apartment_unit"
      end

      def build_apartment_unit_amenities(unit)
        unit.xpath('./Amenity').map do |amenity|
          build_apartment_unit_amenity(amenity)
        end
      end

      def build_apartment_unit_amenity(unit)
        raise NotImplementedError, "#{self.class.to_s} must implement #build_apartment_unit_amenity"
      end

      def build_office_hours(property_xml)
        property_xml.xpath('./Information/OfficeHour').map do |office_hour_node|
          Bozzuto::ExternalFeed::OfficeHour.new(
            :opens_at  => string_at(office_hour_node, './OpenTime'),
            :closes_at => string_at(office_hour_node, './CloseTime'),
            :day       => string_at(office_hour_node, './Day')
          )
        end
      end

      def build_files(node, id)
        node.xpath("./File[@id=\"#{id}\"]").to_a.map do |node|
          source        = string_at(node, './Src')
          name          = string_at(node, './Name')
          filename      = source.split('/').last.to_s
          fallback_name = filename.match(/(?<name>[^\s\.]+)(\.\S+|\z){1}/).try(:[], :name)

          Bozzuto::ExternalFeed::File.new(
            :external_cms_id   => id,
            :external_cms_type => feed_type.to_s,
            :active            => node['active'] == 'false' ? false : true,
            :file_type         => FeedFile.parse_type_from(string_at(node, './Type'), filename),
            :description       => string_at(node, './Description'),
            :name              => name.presence || fallback_name,
            :caption           => string_at(node, './Caption'),
            :format            => string_at(node, './Format'),
            :source            => string_at(node, './Src'),
            :width             => int_at(node, './Width'),
            :height            => int_at(node, './Height'),
            :rank              => string_at(node, './Rank'),
            :ad_id             => string_at(node, './AdID'),
            :affiliate_id      => string_at(node, './AffiliateID')
          )
        end
      end

      # Helpers
      def floor_plan_group(bedrooms, comment)
        case
        when comment.present? && comment =~ /penthouse/i
          'penthouse'
        when bedrooms == 0
          'studio'
        when bedrooms == 1
          'one_bedroom'
        when bedrooms == 2
          'two_bedrooms'
        else
          'three_bedrooms'
        end
      end

      def floor_plan_image_url(property, plan)
        file = plan.at('./File[Rank=1]') || plan.at('./File')

        if file
          string_at(file, './Src')
        else
          nil
        end
      end

      # Helpers for retrieving values
      def value_at(node, xpath, attribute = nil)
        if attribute
          node.at(xpath).try(:[], attribute)
        else
          node.at(xpath).try(:content)
        end
      end

      def string_at(node, xpath, attribute = nil)
        value_at(node, xpath, attribute).to_s.strip
      end

      def int_at(node, xpath, attribute = nil)
        value_at(node, xpath, attribute).to_i
      end

      def float_at(node, xpath, attribute = nil)
        value_at(node, xpath, attribute).to_f
      end

      def date_for(node)
        return if node.nil? || node['Year'].nil? || node['Month'].nil? || node['Day'].nil?

        Date.new(node['Year'].to_i, node['Month'].to_i, node['Day'].to_i)
      end

      def report
        Benchmark.realtime { yield }.tap do |result|
          log_warn("#{feed_type.to_s.titleize} feed finished processing after #{(result / 60).round(2)} minutes.")
        end
      end
    end
  end
end
