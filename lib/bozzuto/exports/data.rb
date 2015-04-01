module Bozzuto
  module Exports
    class Data
      def self.for_communities
        new.communities
      end

      def communities
        ApartmentCommunity.included_in_export.map do |community|
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

          ''.tap do |url|
            unless path =~ %r{^https?://}
              url << (options.delete(:protocol) || 'http')
              url << '://' unless url.match("://")
              url << options.delete(:host)
              url << ":#{options.delete(:port)}" if options.key?(:port)
            end

            url << path
          end
        end
      end

      class Community < ExportableRecord
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
          [].tap do |features|
            if features_page.present?
              (1..3).each do |i|
                if features_page.send("title_#{i}").present?
                  features << OpenStruct.new(
                    :title => features_page.send("title_#{i}"),
                    :text  => features_page.send("text_#{i}")
                  )
                end
              end
            end
          end
        end

        def slides
          slideshow.try(:slides).to_a.map do |slide|
            OpenStruct.new(:image_url => url_for_image(slide.image.url(:slide)))
          end
        end

        def neighborhood_text
          neighborhood_page.try(:content)
        end

        def floor_plans
          super.map { |plan| FloorPlan.new(plan) }
        end

        def promo
          super if super.present? && super.active?
        end

        def full_address
          [address, zip_code].join(' ')
        end

        def directions_url
          "http://maps.google.com/maps?daddr=#{URI.encode(address)}"
        end

        def local_info_feed
          super.try(:url)
        end

        def nearby_communities
          super.included_in_export
        end

        def bozzuto_url
          apartment_community_url(self)
        end

        def listing_image
          url_for_image(super.url)
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
      end
    end
  end
end
