module Bozzuto
  module ExternalFeed
    class Feed
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
      end

      def initialize(file = nil)
        @file = file || default_file
      end

      def feed_name
        self.class.feed_name(feed_type)
      end

      def data
        assert_file_exists

        @data ||= Nokogiri::XML(File.read(file)).tap do |d|
          d.remove_namespaces!
        end
      end

      def properties
        @properties ||= build_properties(data)
      end

      def file=(new_file)
        @file       = new_file
        @data       = nil
        @properties = nil
      end


      private

      def assert_file_exists
        unless file.present? && File.exists?(file)
          raise FeedNotFound.new("File not found: #{file.inspect}")
        end
      end

      # Builder methods. Override these in the subclass to build the objects
      def build_properties(xml)
        data.xpath('/PhysicalProperty/Property').map do |xml|
          build_property(xml)
        end
      end

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

      def build_office_hours(xml)
        hours = xml.xpath('./Information/OfficeHour').map do |hour|
          {
            :open_time  => string_at(hour, './OpenTime'),
            :close_time => string_at(hour, './CloseTime'),
            :day        => string_at(hour, './Day')
          }
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

    end
  end
end
