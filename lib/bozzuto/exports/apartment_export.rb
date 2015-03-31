module Bozzuto
  module Exports
    class ApartmentExport
      FORMATS = {
        :legacy  => Formats::Legacy,
        :mits4_1 => Formats::Mits4_1
      }

      class << self
        FORMATS.each do |(type, _klass)|
          define_method(type) { new(type) }
        end
      end

      attr_reader :format, :export

      delegate :to_xml, :to => :export

      def initialize(format = :legacy)
        @export = FORMATS.fetch(format).new
      end
    end
  end
end
