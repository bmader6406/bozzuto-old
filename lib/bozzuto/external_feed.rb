module Bozzuto
  module ExternalFeed
    autoload :Vaultware,        "bozzuto/external_feed/vaultware"
    autoload :RentCafe,         "bozzuto/external_feed/rent_cafe"
    autoload :PropertyLink,     "bozzuto/external_feed/property_link"
    autoload :Psi,              "bozzuto/external_feed/psi"
    autoload :OccupancyParsers, "bozzuto/external_feed/occupancy_parsers"

    SOURCES = %w(vaultware rent_cafe property_link psi)

    class << self

      def source_name(source)
        return if source.blank?
        I18n.t!("bozzuto.feeds.#{source}")
      end

      def queue!(source)
        raise ArgumentError, "not a valid feed source" unless SOURCES.include?(source)

        klass = "Bozzuto::ExternalFeed::#{source.classify}".constantize
        klass.queue!
      end
    end
  end
end
