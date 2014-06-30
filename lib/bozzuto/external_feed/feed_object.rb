module Bozzuto
  module ExternalFeed
    class FeedObject
      class_attribute :feed_attributes
      class_attribute :database_attributes

      def self.has_attributes_for(type, attrs)
        send("#{type}_attributes=", attrs)

        attr_accessor(*attrs) if type == :feed
      end

      def initialize(attrs)
        self.attributes = attrs
      end

      def feed_attributes
        attributes_hash(self.class.feed_attributes)
      end

      def database_attributes
        attributes_hash(self.class.database_attributes)
      end

      def attributes=(attrs)
        attrs.each do |key, value|
          send("#{key}=", value)
        end
      end


      private

      def attributes_hash(attrs)
        Hash[ attrs.map { |a| [a.to_sym, send(a)] } ]
      end
    end
  end
end
