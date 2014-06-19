module Bozzuto
  module ExternalFeed
    class FeedObject
      class_attribute :database_attributes

      def initialize(attrs)
        attrs.each do |key, value|
          send("#{key}=", value)
        end
      end

      def database_attributes
        attrs = self.class.database_attributes

        Hash[ attrs.map { |a| [a.to_sym, send(a)] } ]
      end
    end
  end
end
