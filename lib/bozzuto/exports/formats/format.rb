module Bozzuto::Exports
  module Formats
    class Format
      def self.to_xml
        new.to_xml
      end

      def to_xml
        builder.PhysicalProperty do |node|
          communities.each do |community|
            property_node(node, community)
          end
        end
      end

      def format_float_for_xml(value)
        if value.present?
          '%g' % value.to_f
        else
          ''
        end
      end

      def strip_tags_and_whitespace(html)
        CGI.unescape sanitizer.sanitize(String(html)).gsub(/\s+/, ' ').strip
      end

      private

      def sanitizer
        @sanitizer ||= Rails::Html::FullSanitizer.new
      end

      def builder
        @builder ||= Builder::XmlMarkup.new(:indent => 2)
      end

      def communities
        @communities ||= Bozzuto::Exports::Data.communities
      end
    end
  end
end
