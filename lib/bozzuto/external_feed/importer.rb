module Bozzuto
  module ExternalFeed
    class Importer
      include XpathParsing

      attr_reader :feed

      delegate :file,
               :mark_as_processing!,
               :mark_as_success!,
               :mark_as_failure!,
               to: :feed

      def initialize(feed)
        raise ArgumentError, "feed state must be queued to import, currently marked as #{feed.state}" unless feed.queued?
        @feed = feed
      end

      def feed_type
        raise NotImplementedError, "#{self.class.to_s} must implement #feed_type"
      end

      def call
        mark_as_processing!
        clear_property_flags

        XmlParser.new(self).parse

        set_property_flags
        mark_as_success!
      rescue => e
        mark_as_failure!(e)
      end

      def collect(node)
        build_property(node).tap do |property_data|
          data       << property_data
          properties << PropertyImporter.new(property_data, feed_type).import
        end
      end

      def data
        @data ||= []
      end

      def properties
        @properties ||= []
      end

      private

      def clear_property_flags
        # Reset found_in_latest_feed on all Properties for the current feed
        ::ApartmentCommunity.where(:external_cms_type => feed_type).found_in_latest_feed.update_all(:found_in_latest_feed => false)

        # Reset include_in_export flag on all Property Link units
        ::ApartmentUnit.where(:external_cms_type => 'property_link').update_all(:include_in_export => false)
      end

      def set_property_flags
        # Update the included_in_export flags based on whether or not it was found in the feed
        ::ApartmentCommunity.where(:external_cms_type => feed_type).find_each do |community|
          community.update_attributes(:included_in_export => community.found_in_latest_feed?)
        end
      end

      def build_property(property)
        raise NotImplementedError, "#{self.class.to_s} must implement #build_property"
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

      def build_floor_plans(property)
        property.xpath('./Floorplan').map do |plan|
          build_floor_plan(property, plan)
        end
      end

      def build_floor_plan(property, plan)
        raise NotImplementedError, "#{self.class.to_s} must implement #build_floor_plan"
      end

      def build_apartment_units(property)
        property.xpath('./ILS_Unit').map do |unit|
          build_apartment_unit(property, unit)
        end
      end

      def build_apartment_unit(property, unit)
        raise NotImplementedError, "#{self.class.to_s} must implement #build_apartment_unit"
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

      def build_apartment_unit_amenities(unit)
        unit.xpath('./Amenity').map do |amenity|
          build_apartment_unit_amenity(amenity)
        end
      end

      def build_apartment_unit_amenity(unit)
        raise NotImplementedError, "#{self.class.to_s} must implement #build_apartment_unit_amenity"
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
    end
  end
end
