module Bozzuto
  module Exports
    class Data
      def self.communities
        new.communities
      end

      def self.combined_communities
        new.combined_communities
      end

      def communities
        Bozzuto::ExternalFeed::CoreIdManager.canonical_communities(ApartmentCommunity.included_in_export).map do |community|
          Community.new(community)
        end
      end

      def combined_communities
        communities + HomeCommunity.published.map do |community|
          Community.new(community)
        end
      end

      private

      class ExportableRecord < SimpleDelegator
        include Rails.application.routes.url_helpers
        include PropertiesHelper

        default_url_options[:host] = ActionMailer::Base.default_url_options[:host] || 'bozzuto.com'

        def url_for_image(path, options={})
          options = default_url_options.merge(options)

          URI.parse(URI.encode(path)).tap do |url|
            url.scheme ||= options[:protocol] || 'http'
            url.host   ||= options[:host]
            url.port   ||= options[:port]
          end.to_s
        end
      end

      class Community < ExportableRecord
        def id
          apartment_community? ? id_for_export : super
        end

        def city
          super.name
        end

        def state
          __getobj__.city.state.code
        end

        def county
          super.try(:name)
        end

        def features
          features_page.try(:features) || []
        end

        def slides
          slideshow.try(:slides).to_a.map do |slide|
            OpenStruct.new(image_url: url_for_image(slide.image.url(:slide)))
          end
        end

        def neighborhood_text
          neighborhood_page.try(:content)
        end

        def floor_plans
          return [] if home_community?

          super.map { |plan| FloorPlan.new(plan) }
        end

        def promo
          super if super.present? && super.active?
        end

        def zip
          zip_code
        end

        def address_line_1
          street_address
        end

        def directions_url
          "http://maps.google.com/maps?daddr=#{URI.encode(address)}"
        end

        def nearby_communities
          return [] if home_community?

          super.included_in_export
        end

        def website_url
          super.presence || bozzuto_url
        end

        def bozzuto_url
          if home_community?
            home_community_url(self)
          else
            apartment_community_url(self)
          end
        end

        def listing_image
          url_for_image(super.url)
        end

        def video_url
          super.presence
        end

        def lead_2_lease_email
          super if apartment_community?
        end

        def pinterest_url
          super if apartment_community?
        end
      end

      class FloorPlan < ExportableRecord
        def image_url
          url_for_image(actual_image) if actual_image.present?
        end

        def min_rent
          available_units.zero? ? 0 : super
        end

        def max_rent
          available_units.zero? ? 0 : super
        end

        def units
          apartment_units.map { |unit| Unit.new(unit) }
        end
      end

      class Unit < ExportableRecord
        def name
          marketing_name.presence || external_cms_id
        end

        def unit_rent
          super.presence || market_rent
        end

        def market_rent
          super.presence || max_rent
        end

        def sync_id
          external_cms_type == 'rent_cafe' ? building_external_cms_id : external_cms_id
        end

        def address_line_1
          super.presence || floor_plan.apartment_community.street_address
        end

        def city
          super.presence || floor_plan.apartment_community.city.name
        end

        def state
          super.presence || floor_plan.apartment_community.state.code
        end

        def zip
          super.presence || floor_plan.apartment_community.zip_code
        end
      end
    end
  end
end
