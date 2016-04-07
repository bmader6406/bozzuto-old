module Bozzuto
  module Exports
    class ApartmentExport
      FORMATS = [
        Formats::Legacy
      ]

      LOOKUP = lambda do |format|
        {
          /legacy/i => Formats::Legacy,
        }.find { |(regex, path)| format.match(regex) }.try(:last)
      end

      UnrecognizedFormatError = Class.new(StandardError)

      attr_reader :export

      delegate :to_xml, :to => :export

      def initialize(format = :legacy)
        format_class = LOOKUP[format.to_s]

        raise UnrecognizedFormatError if format_class.nil?

        @export = format_class.new
      end

      def deliver
        File.open(file, 'w') { |f| f.write(export.to_xml) }

        Bozzuto::ExternalFeed::QburstFtp.transfer file
      end

      def file
        @file ||= export.class.const_get(:PATH)
      end
    end
  end
end
